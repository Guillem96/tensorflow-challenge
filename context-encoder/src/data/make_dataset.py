# -*- coding: utf-8 -*-
import click
import logging
from pathlib import Path
from dotenv import find_dotenv, load_dotenv
import os
import requests

from PIL import Image
load_dotenv(find_dotenv())

logger = logging.getLogger(__name__)
logger.info('making final data set from raw data')

@click.group()
def main():
    pass

@main.command()
@click.argument('input_filepath', type=click.Path(exists=True))
@click.argument('output_filepath', type=click.Path())
def no_name(input_filepath, output_filepath):
    """ Runs data processing scripts to turn raw data from (../raw) into
        cleaned data ready to be analyzed (saved in ../processed).
    """
    pass

@main.command()
@click.option('--urls-file', 
                default=str(Path(os.environ['DATA_DIR'], 'raw', 'image_net', 'fall11_urls.txt')), 
                type=click.Path(exists=True))
@click.option('--images_dir',
                default=str(Path(os.environ['DATA_DIR'], 'processed', 'image_net')))
@click.option('--num', default=1000, type=int)
def generate_imagenet(urls_file, images_dir, num):
    def download_image_resize(url, name):
        resized_dir = Path(images_dir, 'resized')
        original_dir = Path(images_dir, 'original')
        original_dir.mkdir(exist_ok=True)
        resized_dir.mkdir(exist_ok=True)

        try:
            res = requests.get(url)
            if res.status_code == 200:
                f = open(str(original_dir.joinpath(name)), 'wb')
                f.write(res.content)
                f.close()
            else:
                return

            img = Image.open(str(original_dir.joinpath(name)))
            img = img.resize((200, 200))
            if img.mode != 'RBG':
                img = img.convert('RGB')
            img.save(str(resized_dir.joinpath(name)), 'JPEG')
        
        except KeyboardInterrupt:
            import sys
            sys.exit(0)

        except:
            logger.info('Error downloding image ' + name)

            if resized_dir.joinpath(name).exists():
                resized_dir.joinpath(name).unlink()
            return

    img_path = Path(images_dir)
    img_path.mkdir(parents=True, exist_ok=True)

    with Path(urls_file).open(encoding='latin-1') as f:
        for idx, line in enumerate(f.readlines()[:num]):
            url = line.split('\t')[1].strip()
            name = str(idx) + '.jpg'
            download_image_resize(url, name)


if __name__ == '__main__':
    log_fmt = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    logging.basicConfig(level=logging.INFO, format=log_fmt)

    # find .env automagically by walking up directories until it's found, then
    # load up the .env entries as environment variables

    main()
