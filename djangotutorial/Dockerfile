# pull official base image
ARG PYTHON_VERSION=3.11-alpine
FROM python:${PYTHON_VERSION}

ENV HOME=/usr/src
ENV APP_HOME=$HOME/app

RUN apk update \
    && apk add git

RUN pip install --upgrade pip --no-cache-dir

WORKDIR $APP_HOME

COPY requirements.txt .

RUN mkdir -p $APP_HOME/logs
RUN chmod -R 755 $APP_HOME/logs

RUN pip install -r requirements.txt

COPY . .
