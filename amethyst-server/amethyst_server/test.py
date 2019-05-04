import base64
from PIL import Image
from io import BytesIO
import requests

import base64

with open("prova.jpg", "rb") as image_file:
    encoded_string = base64.b64encode(image_file.read())

res = requests.post('http://localhost:5000/complete-image', json={'img': encoded_string.decode('ascii')})

import base64
with open("aver.jpg", "wb") as fh:
    fh.write(base64.b64decode(res.json()['predict']))