# -*- coding: utf-8 -*-
from helpers import *
from helpers_cntk import *
import os
locals().update(importlib.import_module("PARAMETERS").__dict__)

####################################
# Define input arguments
####################################

parser = argparse.ArgumentParser(description='Image similarity ranking')
parser.add_argument('inputDirectory',
                    help='Path to the input directory.')
args = parser.parse_args()
print(sys.argv)
print("Test")

####################################
# Specify Input Image Data for Scoring
####################################

# makeDirectory(rootDir + "/data/")
# makeDirectory(imgDir)
imgDir = sys.argv[1]
print(imgDir)

####################################
# Prepare Data
####################################
random.seed(0)
makeDirectory(procDir)
imgFilenamesTest  = dict()
imgFilenamesTrain = dict()

print("[InProgress] Preparing test images...")
subdirs = getDirectoriesInDirectory(imgDir)
for subdir in subdirs:
    filenames = getFilesInDirectory(imgDir + subdir, ".jpg")
    
    # Assign images into test
    if imagesSplitBy == 'filename':
        filenames  = randomizeList(filenames)
        splitIndex = int(0 * len(filenames))
        imgFilenamesTrain[subdir] = filenames[:splitIndex]
        imgFilenamesTest[subdir]  = filenames[splitIndex:]
        
    # Assign whole subdirectories to test
    elif imagesSplitBy == 'subdir':
        if random.random() < 0:
            imgFilenamesTrain[subdir] = filenames
        else:
            imgFilenamesTest[subdir]  = filenames
    else:
        raise Exception("Variable 'imagesSplitBy' has to be either 'filename' or 'subdir'")

    # Debug print
    if subdir in imgFilenamesTest:
        print("Testing:  {:5} images in directory {}".format(len(imgFilenamesTest[subdir]), subdir))


# Save assignments of images to test
saveToPickle(imgFilenamesTestPath,  imgFilenamesTest)

# Compute positive and negative image pairs
print("[InProgress] Computing image pairs for test data ...")
imgInfosTest = getImagePairs(imgFilenamesTest, test_maxQueryImgsPerSubdir, test_maxNegImgsPerQueryImg)
saveToPickle(imgInfosTestPath, imgInfosTest)

print("[Complete] Data preparation")

################################################
# Featurize Images
################################################
# Init
printDeviceType()
makeDirectory(workingDir)
model = load_model(cntkRefinedModelPath)

# Compute features for each image and write to disk
print("[InProgress] Featurizing test set..")
featuresTest  = featurizeImages(model, imgFilenamesTestPath,  imgDir, workingDir + "/featurizer_map.txt", "poolingLayer", run_mbsize)
features = featuresTest
for feat in list(features.values()):
    assert(len(feat) == rf_modelOutputDimension)

# Save features to file
print("[Complete] Writing CNTK outputs to file %s ..." % featuresPath)
saveToPickle(featuresPath, features)
print("[Complete] Featurization.2")

####################################
# Score SVM
####################################
# Parameter

distMethods = ['random', 'L1', 'L2', 'weighted'+svm_featureDifferenceMetric]  #'cosine', 'correlation', 'chiSquared', 'normalizedChiSquared']

# No need to change below parameters
boVisualizeResults  = True
boEvalOnTrainingSet = False  # Set to 'False' to evaluate using test set; 'True' to instead eval on training set
visualizationDir = resultsDir + "visualizations_weightedl2/" + "score_results/"

random.seed(0)

# Load trained svm
learner    = loadFromPickle(svmPath)
svmBias    = learner.base_estimator.intercept_
svmWeights = np.array(learner.base_estimator.coef_[0])

# Load data
print("[InProgress] Loading featurized test data...")
ImageInfo.allFeatures = loadFromPickle(featuresPath)
imgInfos = loadFromPickle(imgInfosTestPath)

# Compute distances between all image pairs
print("[InProgress] Computing pair-wise distances...")
allDists = { queryIndex:collections.defaultdict(list) for queryIndex in range(len(imgInfos)) }
for queryIndex, queryImgInfo in enumerate(imgInfos):
    queryFeat = queryImgInfo.getFeat()
    if queryIndex % 50 == 0:
        print("Computing distances for query image {} of {}: {}..".format(queryIndex, len(imgInfos), queryImgInfo.fname))

    # Loop over all reference images and compute distances
    for refImgInfo in queryImgInfo.children:
        refFeat = refImgInfo.getFeat()
        for distMethod in distMethods:
            dist = computeVectorDistance(queryFeat, refFeat, distMethod, svm_boL2Normalize, svmWeights, svmBias)
            allDists[queryIndex][distMethod].append(dist)
# Find match with minimum distance (rank 1)
print("[InProgress] Showing matching image with minimum weightedl2 distance for query image: ")
fmt = "{0:<15.15} : {1:<15.15} : {2:<15.15} : {3:<15.15} : {4:<10.10}"
print(fmt.format("queryImgName", "queryLabel", "matchingImgName", "minDistLabel", "minDist"))

fmt = "{0:<15.15} : {1:<15.15} : {2:<15.15} : {3:<15.15} : {4:<10.2f}"
for queryIndex, queryImgInfo in enumerate(imgInfos):
    dists = allDists[queryIndex]["weightedl2"]
    # Find match with minimum distance (rank 1)
    sortOrder = np.argsort(dists)
    minDistIndex = sortOrder[0]
    minDist      = dists[minDistIndex]
    queryImgName     = queryImgInfo.fname
    minDistImgName   = imgInfos[queryIndex].children[minDistIndex].fname
    queryLabel = queryImgInfo.subdir
    minDistLabel = imgInfos[queryIndex].children[minDistIndex].subdir
    print(fmt.format(queryImgName, queryLabel, minDistImgName, minDistLabel, minDist))

# Check whether display is available
displayAvailable = os.path.exists("display.py")

if (displayAvailable):
    
    # Visualize
    if boVisualizeResults:
        makeDirectory(resultsDir)
        makeDirectory(visualizationDir)
        print("Writing images to " +  visualizationDir)

        # Loop over all query images
        for queryIndex, queryImgInfo in enumerate(imgInfos):
            # print("   Visualizing result for query image: " + imgDir + queryImgInfo.fname)
            dists = allDists[queryIndex]["weightedl2"]

            # Find match with minimum distance (rank 1)
            sortOrder = np.argsort(dists)
            minDistIndex = sortOrder[0]
            minDist      = dists[minDistIndex]
            queryImg     = queryImgInfo.getImg(imgDir)
            minDistImg   = imgInfos[queryIndex].children[minDistIndex].getImg(imgDir)
        
            # Visualize
            plt.rcParams['figure.facecolor'] = 'blue' 
        
            pltAxes = [plt.subplot(1, 2, i+1) for i in range(2)]
            for ax, img, title in zip(pltAxes, (queryImg, minDistImg),
                                  ('Query image', 'MinDist match \n (dist={:3.2f})'.format(minDist))):
                ax.imshow(imconvertCv2Numpy(img))
                ax.axis('off')
                ax.set_title(title)
            plt.draw()
            plt.savefig(visualizationDir + "/" + queryImgInfo.fname.replace('/','-'), dpi=200, bbox_inches='tight', facecolor=plt.rcParams['figure.facecolor'])

    msg = """
The individual classified images, such as the final image, can be displayed:

 $ ml display clothes-design-similarity score {}
""".format(queryImgInfo.fname.replace('/','-'))
    print(msg)
else:
    print("")

