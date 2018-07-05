# import the necessary packages
import os

import cv2 as cv

from utils import predict

if __name__ == '__main__':
    image_folder = 'images'
    image_name = os.path.join(image_folder, 'sample.png')
    gray = cv.imread(image_name, 0)
    out = predict(gray)

    cv.imwrite('images/output.png', out)
