import os

from PIL import Image, ImageDraw, ImageFont
import numpy as np
import matplotlib.pyplot as plt

import dotenv
dotenv.load_dotenv(dotenv.find_dotenv())

_LOREM_IPSUM = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

def generate_text_mask(original_arr):
    def pick_random_words(n_word=5, text=_LOREM_IPSUM):
        splited_lorem = text.split()
        idx = np.random.randint(0, len(splited_lorem), n_word)
        return ' '.join([splited_lorem[i] for i in idx])
    def rotate_image(img):
        rotation = np.random.choice([0, 90, 180, 270])
        return img.rotate(rotation)
    def write_random(img):
        fnt_size = int(img.size[0] * .2)
        fnt = ImageFont.truetype(os.environ['FONT'], fnt_size)
        d = ImageDraw.Draw(img)
        
        curr_pos = 5
        while curr_pos < img.size[1]:
            if np.random.random() > .35:
                d.text((10, curr_pos), pick_random_words(), font=fnt, fill=(255, 0, 255))
            curr_pos += int(fnt_size * 1.1)

    masked = original_arr.copy()
    mask = Image.fromarray(np.uint8(masked * 255))
    write_random(mask)
    mask = rotate_image(mask)
    return np.asarray(mask) / 255.

def drop_pixels(original):
    rate = np.random.choice(np.arange(.1, .5, .1))
    random_mask = np.random.random(size=(original.shape[:-1]))
    random_idx = random_mask <= rate
    
    masked = original.copy()
    masked[random_idx] = np.array([1., 0., 1.])
    
    return masked

def drop_pixels_tensor(original_tensor):
    rate = np.random.choice(np.arange(.1, .5, .1))
    random_mask = np.random.random(size=original_tensor.shape[:-1])
    random_idx = random_mask <= rate
    
    masked = original_tensor.copy()
    masked[random_idx] = np.array([1., 0., 1.])
    
    return masked

def generate_lines_mask(original_arr, min_width=2, max_width=4):
    line_width = np.random.randint(min_width - 1, max_width + 1)
    n_vertical_lines = np.random.randint(3, 9)
    n_horizontal_lines = np.random.randint(3, 9)
    
    hozizontal_lines_pos = np.random.randint(0, original_arr.shape[0], size=n_horizontal_lines)    
    hozizontal_lines_len = np.random.randint(original_arr.shape[0] // 1.5, original_arr.shape[0], size=(n_horizontal_lines))
    
    vertical_lines_pos = np.random.randint(0, original_arr.shape[1], size=(n_vertical_lines))    
    vertical_lines_len = np.random.randint(original_arr.shape[1] // 1.5, original_arr.shape[1], size=(n_vertical_lines))

    masked = original_arr.copy()
    mask = Image.fromarray(np.uint8(masked * 255))
    
    d = ImageDraw.Draw(mask)
    for i in range(n_horizontal_lines):
        d.line((hozizontal_lines_pos[i], 
                hozizontal_lines_pos[i], 
                hozizontal_lines_pos[i] + hozizontal_lines_len[i], 
                hozizontal_lines_pos[i]), 
               fill=(255, 0, 255), width=line_width)
    
    for i in range(n_vertical_lines):
        d.line((vertical_lines_pos[i], 
                vertical_lines_pos[i], 
                vertical_lines_pos[i], 
                vertical_lines_pos[i] + vertical_lines_len[i]), 
               fill=(255, 0, 255), width=line_width)
    
    return np.asarray(mask) / 255.
