import os
import sys
import dotenv
from pathlib import Path
from functools import partial

from PIL import Image
import numpy as np

sys.path.append('..')
from data.masks import *

dotenv.load_dotenv(dotenv.find_dotenv())

from gan import *
lsgan.load_weights(os.environ['MODELS_DIR'] + '/lsgan_pink_model.h5')


def mask_randomly(imgs):
    transformations = [partial(drop_pixels, colors=[(255, 0, 255)]),          # Drop some random pixels
                       partial(generate_lines_mask, colors=[(255, 0, 255)]),  # Draw vertical and horizontal lines over the image
                       partial(generate_text_mask, colors=[(255, 0, 255)])]   # Write text over the image
    masked_imgs = np.empty_like(imgs)
    for i, img in enumerate(imgs):
        masked_imgs[i] = random.choice(transformations)(img)
        
    return masked_imgs

def pick_random_images(n_images=3):
    def image_to_arr(img):
        img = Image.open(img)
        resized = img.resize((512, 512))
        return np.asarray(resized) / 255.

    possible_images = list(Path(os.environ['DATA_DIR'] + '/raw/0').glob('*.jpg'))
    original_images = np.random.choice(possible_images, size=n_images)
    return [image_to_arr(img) for img in original_images]

def sample_images(imgs, masked_imgs, gen_img, file_name='sample.png'):
    r, c = 3, gen_img.shape[0]

    fig, axs = plt.subplots(r, c, figsize=(15, 10))
    for i in range(c):
        axs[0,i].imshow(imgs[i])
        axs[0,i].axis('off')
        axs[1,i].imshow(masked_imgs[i])
        axs[1,i].axis('off')
        axs[2,i].imshow(gen_img[i])
        axs[2,i].axis('off')
    plt.savefig(os.environ['REPORTS_DIR'] + '/figures/' + file_name)

original_images = pick_random_images()    
masked_images = mask_randomly(original_images)
generated_images = generator.predict(masked_images)

sample_images(original_images, masked_images, generated_images)
