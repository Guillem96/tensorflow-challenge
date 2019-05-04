import tensorflow as tf 

class Decoder(tf.keras.Model):
    def __init__(self):
        super(Decoder, self).__init__(name = 'Decoder')
        
        self.conv_1 = tf.keras.layers.Conv2D(64, kernel_size=2, padding='same')
        self.deconv_1 = tf.keras.layers.Conv2DTranspose(64, kernel_size=2, strides=2, padding='same')
        self.elu_1 = tf.keras.layers.ELU()
        
        self.conv_2 = tf.keras.layers.Conv2D(32, kernel_size=2, padding='same')
        self.deconv_2 = tf.keras.layers.Conv2DTranspose(32, kernel_size=2, strides=2, padding='same')
        self.elu_2 = tf.keras.layers.ELU()
        
        self.conv_3 = tf.keras.layers.Conv2D(3, kernel_size=2, padding='same')
        self.deconv_3 = tf.keras.layers.Conv2DTranspose(3, kernel_size=2, strides=2, padding='same')
        
    def call(self, input_tensor, training=False, **kwargs):
        x = self.conv_1(input_tensor)
        x = self.deconv_1(x)
        x = self.elu_1(x)
        
        skip_1 = tf.keras.layers.concatenate([x, kwargs['strided_conv_2']], 3)
        
        x = self.conv_2(skip_1)
        x = self.deconv_2(x)
        x = self.elu_2(x)
        
        skip_2 = tf.keras.layers.concatenate([x, kwargs['strided_conv_1']], 3)
        
        x = self.conv_3(skip_2)
        x = self.deconv_3(x)
        
        return x