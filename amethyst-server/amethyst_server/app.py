import os
from pathlib import Path

from flask_cors import CORS
from flask import Flask, request, jsonify

from ml_service import MlService

app = Flask(__name__)
ml_service = MlService()

CORS(app)

@app.route('/')
def hello_world():
    return 'Hello, cross-origin-world!'

@app.route('/complete-image', methods=['POST'])
def complete_image():
    data = request.get_json()
    if data is None:
        print("No valid request body, json missing!")
        return jsonify({'error': 'No valid request body, json missing!'}), 400
    else:
        return jsonify(dict(predict=ml_service.predict(data['img'])))

if __name__ == "__main__":
    app.run('0.0.0.0', debug=True)