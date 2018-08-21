# -*- coding: utf-8 -*-
from helpers import *
from helpers_cntk import *
import matplotlib.image as mpimg
from sys import platform
import subprocess
locals().update(importlib.import_module("PARAMETERS").__dict__)

####################################
# Print model
####################################

makeDirectory(workingDir)
cntk_model = load_model(cntkRefinedModelPath)

cntkRefinedModelVisPath = procDir + "cntk_model.png"
graph.plot(cntk_model, cntkRefinedModelVisPath)

if (platform == "linux" or platform == "linux2"):
    try:
        subprocess.call(["eog", cntkRefinedModelVisPath])
    except OSError as e:
        if e.errno == os.errno.ENOENT:
            img = mpimg.imread(cntkRefinedModelVisPath)
            plt.imshow(img)
            plt.show()            
else:
    img = mpimg.imread(cntkRefinedModelVisPath)
    plt.imshow(img)
    plt.show()
    

