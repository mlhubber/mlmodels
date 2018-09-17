# Import the necessary packages.

import os
import cv2 as cv
import glob

from utils import predict

if __name__ == '__main__':
    image_folder = 'images'

    images = glob.glob("images/*_bw.png")
    images.sort()

    cwd = os.getcwd()
    for image in images:
        print("Colorize " + os.path.join(cwd, image))
        gray = cv.imread(image, 0)
        out = predict(gray)
        cv.imwrite(image.replace("bw", "color"), out)

msg = """
The individual colorized images can be displayed:

 $ ml display colorize
"""
print(msg)

