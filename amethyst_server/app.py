from pathlib import Path

from flask_cors import CORS
from flask import Flask, request, redirect, jsonify, url_for, send_from_directory
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = Path('upload/')

CORS(app)

ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def hello_world():
    return 'Hello, cross-origin-world!'

@app.route('/complete-image', methods=['POST'])
def complete_image():
    # check if the post request has the file part
    if 'image' not in request.files:
        return jsonify(dict(error='No image provided')), 400

    image = request.files['image']

    # if user does not select file, browser also
    # submit a empty part without filename
    if image.filename == '':
        return jsonify(dict(error='No image selected')), 400

    if image and allowed_file(image.filename):
        filename = secure_filename(image.filename)
        image.save(str(app.config['UPLOAD_FOLDER'].joinpath(filename)))
        return redirect(url_for('uploaded_file',
                                filename=filename))

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(str(app.config['UPLOAD_FOLDER']), filename)

if __name__ == "__main__":
    app.run('0.0.0.0', debug=True)