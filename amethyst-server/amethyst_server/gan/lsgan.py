import tensorflow as tf
from .discriminator import Discriminator
from .generator import Generator

def create_lsgan():
    optimizer = tf.keras.optimizers.Adam(0.0002, .5)

    # Give fixed inputs to discriminator and generator
    images = tf.keras.layers.Input(shape=(None, None, 3))
    discriminator = Discriminator()
    discriminator = tf.keras.Model(images, discriminator(images))

    discriminator.trainable = True
    discriminator.compile(optimizer=optimizer,
                        loss='binary_crossentropy',
                        metrics=['accuracy'])

    masked_images = tf.keras.layers.Input(shape=(None, None, 3))
    generator = Generator()
    generator = tf.keras.Model(masked_images, generator(masked_images))

    # Join the discriminator and generator
    discriminator.trainable = False

    lsgan_input = tf.keras.layers.Input(shape=(None, None, 3))
    generated = generator(lsgan_input)
    is_valid = discriminator(generated)

    lsgan = tf.keras.Model(lsgan_input, [generated, is_valid])
    lsgan.compile(optimizer=optimizer,
                loss=['mse', 'binary_crossentropy'],
                loss_weights=[0.999, 0.001])

    return dict(lsgan=lsgan, generator=generator, discriminator=discriminator)