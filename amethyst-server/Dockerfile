FROM python:3.6

WORKDIR /app

COPY requirements.txt /app

RUN pip install -r requirements.txt

COPY . .

ENV MODEL_DIR=/app/model

CMD [ "python", "./app.py" ]