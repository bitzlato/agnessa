import sys
from deepface import DeepFace

img_path = sys.argv[1]
model_name = sys.argv[2]
detector_backend = sys.argv[3]
embedding = DeepFace.represent(img_path, model_name = model_name, detector_backend = detector_backend)
print('result')
print(embedding)