# -*- coding: utf-8 -*-

from helpers import *
#from helpers_cntk import *
from PIL import Image
from sys import platform
import subprocess

locals().update(importlib.import_module("PARAMETERS").__dict__)

####################################
# Define input arguments
####################################

parser = argparse.ArgumentParser(description='Image similarity ranking')
parser.add_argument('resultFolder', nargs='?',
                    help='Name of the subfolder to display.')
parser.add_argument('inputImage', nargs="*",
                    help='Name of the image to display.')

args = parser.parse_args()

if (len(sys.argv) != 2):
    sys.argv = [sys.argv, "demo"]

####################################
# Display visualization results
####################################

visualizationDir = resultsDir + "visualizations_weightedl2/" + sys.argv[1] + "_results/"

if len(sys.argv) == 2 and (platform == "linux" or platform == "linux2"):
    try:
        subprocess.call(["eog", visualizationDir])
    except OSError as e:
        if e.errno == os.errno.ENOENT:
            image = Image.open(visualizationDir)
            image.show()
else:
    image = Image.open(visualizationDir + sys.argv[2])
    image.show()


