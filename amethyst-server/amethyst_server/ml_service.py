import base64
import os
from io import BytesIO

from PIL import Image
import numpy as np

from gan import create_lsgan

class MlService(object):
    
    def __init__(self):
        self.lsgan_models = create_lsgan()
        self.lsgan_models['lsgan'].load_weights(os.environ['MODEL_DIR'] + '/lsgan_pink_model.h5')
    
    def _img_preprocess(self, image):
        img = Image.open(BytesIO(base64.b64decode(image))).convert('RGB')
        resized = img.resize((512, 512))
        return np.asarray(resized) / 255.

    def _img_postprocess(self, image):
        img = Image.fromarray(np.uint8(image * 255))
        buffered = BytesIO()
        img.save(buffered, format="JPEG")
        img_str = base64.b64encode(buffered.getvalue())

        return img_str.decode('ascii')

    def predict(self, image):
        img = self._img_preprocess(image)
        prediction = self.lsgan_models['generator'].predict(img.reshape((1,) + img.shape))
        return self._img_postprocess(prediction[0])

        