# Amethyst

This repo is the implementation of my project proposal for (Tensorflow 2.0 Challenge)[https://tensorflow.devpost.com/].

## What is amethyst

Amethyst is an intelligent photo editor which is capable to remove undesired parts of the images. To clean an image you just have to paint over the annoying item and Amethyst will automatically delete it for you!

Amethyst is an hybrid mobile application (able to work either on IOS or Android) developed using flutter.

Example:

## How it works?

Amethyst uses a complex GAN architecture to regenerate the drew part of the image. As the compute power and time is limited Amethyst uses the lightweighted GAN discribed on this (paper)[https://www.dropbox.com/s/e4l19y9ggqqk2yf/0360.pdf?dl=1].

The goal of this Neural Network is to complete the missing parts of the images based on the general context of the image.

To summarize the Amethyst AI is capable of removing corruption masks over an image using the generic context of the image.  

### Amethyst GAN

The GAN which is goal is to commplete missing parts of images is formed by:

- Generator: Recieves the corrupted image and removes the corruption. This generator is quite special and is composed by to parts
  - **Semantic Encoder**: Its goal is to generate a feature map capable of containing the most important images' features.
  - **Decoder**: Decodes the features generated with **Semantic Encoder** and generates the image without the corruption mask.

- **Discriminator**: NN to help during training, it differenciates between generated and original images without corruption mask. Helps on the backpropagation step influencing to the generator in creating more realistic images.
