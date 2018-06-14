FROM ubuntu:18.04
#FROM python:3.5

WORKDIR /code

RUN apt-get update && apt-get install -y \
  python3-minimal \
  python3-pip \
  terraform \
  packer

COPY ./requirements.txt /code/
RUN pip3 install -r requirements.txt

