FROM python:3.6

WORKDIR /app

COPY requirements.txt /app

RUN pip install -r requirements.txt

COPY model /app/model
COPY amethyst_server /app

ENV MODEL_DIR=/app/model

RUN adduser --disabled-login myuser
USER myuser

CMD gunicorn --bind 0.0.0.0:$PORT wsgi 
