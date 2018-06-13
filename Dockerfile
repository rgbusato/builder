FROM python:3.5

WORKDIR /code

RUN apt-get update && apt-get install netcat -y
COPY ./requirements.txt /code/
RUN pip install -r requirements.txt

