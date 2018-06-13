# Use an official Python runtime as a parent image
FROM python:3.5

# Set the working directory to /app
WORKDIR /code

RUN apt-get update && apt-get install netcat -y
COPY ./requirements.txt /code/
RUN pip install -r requirements.txt

