import cv2
import os
import coremltools as ct

mlmodel = ct.convert('model.mlmodel')