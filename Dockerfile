FROM python:buster

RUN apt-get update && apt-get install -y vim

RUN pip install -U pip poetry

WORKDIR /opt
COPY . .

ENTRYPOINT /bin/bash
