import sys
from deepface import DeepFace

# VGG-Face, Facenet, OpenFace, DeepFace, DeepID, Dlib or Ensemble
model_name='VGG-Face'

# detector_backend (string): set face detector backend as retinaface, mtcnn, opencv, ssd or dlib
detector_backend = 'opencv'

img_path = sys.argv[1]
embedding = DeepFace.represent(img_path, model_name = model_name, detector_backend = detector_backend)
print('result')
print(embedding)