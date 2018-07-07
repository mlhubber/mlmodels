# Import the necessary packages.

import os
import cv2 as cv
import glob
import sys

#from utils import predict

if __name__ == '__main__':
    image_folder = sys.argv[1]

    images = glob.glob(os.path.join(image_folder, "*.png"))
    images.sort()

    for image in images:
        print("Colorize " + image)
        gray = cv.imread(image, 0)
        out = predict(gray)
        cv.imwrite(image.replace(".png", "_color.png"), out)

msg = """
The individual colorized images can be displayed from
the folder '{}'
""".format(image_folder)
print(msg)

