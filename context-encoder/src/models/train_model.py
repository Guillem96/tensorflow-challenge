import os
import random
import dotenv
import sys

import numpy as np
import tensorflow as tf

sys.path.append('..')
from data.masks import *

from gan import *

dotenv.load_dotenv(dotenv.find_dotenv())

DATA_DIR  = os.environ['DATA_DIR'] + '/raw'
MODELS_DIR  = os.environ['MODELS_DIR']'

def train_data_generator(batch_size = 16):
    datagen = tf.keras.preprocessing.image.ImageDataGenerator(
                rescale=1./255,
                rotation_range=40,
                width_shift_range=0.2,
                height_shift_range=0.2,
                shear_range=0.2,
                zoom_range=0.2,
                horizontal_flip=True,
                fill_mode='nearest')

    train_generator = datagen.flow_from_directory(
            DATA_DIR,
            target_size=(256, 256),
            batch_size=batch_size,
            class_mode=None)

    return train_generator

def mask_randomly(imgs):
    transformations = [drop_pixels,          # Drop some random pixels
                       generate_lines_mask,  # Draw vertical and horizontal lines over the image
                       generate_text_mask]   # Write text over the image
    masked_imgs = np.empty_like(imgs)
    for i, img in enumerate(imgs):
        masked_imgs[i] = random.choice(transformations)(img)
        
    return masked_imgs

def train(batch_size=16, steps=60000):
    train_generator = train_data_generator(batch_size)

    # Adversarial ground truths
    valid = np.ones((batch_size, 1))
    fake = np.zeros((batch_size, 1))

    for step in range(steps):
        # Sample the original images and randomly mask them
        original = next(train_generator)
        masked_images = mask_randomly(original)
        
        # Generate images
        gen = generator.predict(masked_images)
            
        # Train discriminator with the generated images
        d_loss_real = discriminator.train_on_batch(original, valid)
        d_loss_fake = discriminator.train_on_batch(gen, fake)
        d_loss = 0.5 * np.add(d_loss_real, d_loss_fake)
        
        # Train LSGAN
        g_loss = lsgan.train_on_batch(masked_images, [original, valid])
        
        if step % 10 == 0:
            print ("%d [D loss: %f, acc: %.2f%%] [G loss: %f, mse: %f]" % (step, d_loss[0], 100*d_loss[1], g_loss[0], g_loss[1]))
        
        if step % 100 == 0:
            # Save the model every 100 steps
            lsgan.save_weights(MODELS_DIR + '/lsgan_weights.h5')
            
        if step % 400 == 0:
            train_generator.reset()

if __name__ == "__main__":
    train()