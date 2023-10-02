FROM python:3.11.3-alpine3.18

LABEL mantainer="CyroMatheusBG"

RUN apk add openrc bash curl vim nano git zip unzip nginx make gcc g++ libc-dev linux-headers nodejs npm postgresql-libs musl-dev postgresql-dev && \
    mkdir -p /run/nginx && \
    pip install uwsgi uwsgitop

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    echo "export LS_OPTIONS='--color=auto'" >>~/.bashrc && \
    echo "alias ls='ls \$LS_OPTIONS'" >>~/.bashrc && \
    echo "alias ll='ls \$LS_OPTIONS -l'" >>~/.bashrc && \
    echo "alias l='ls \$LS_OPTIONS -lA'" >>~/.bashrc

RUN mkdir /appdata
WORKDIR /application

COPY ./app/requirements.txt ./app/requirements.txt
RUN pip install -r ./app/requirements.txt

COPY front/package.json front/package.json
COPY front/package-lock.json front/package-lock.json
RUN cd front && npm install && npm install -g pm2
COPY front front
RUN cd front && npm run build

ENV SHELL=/bin/bash PYTHONUNBUFFERED=1 NODE_ENV=production PYTHONIOENCODING=UTF-8 LANG=en_US.UTF-8 STATIC_ROOT=/appdata/static LOG_FILE=/appdata/application.log UWSGI_PROCESSES=3 PORT=3000 HOST=0.0.0.0 API_BASE_URL=http://localhost:8000

COPY . /application
COPY docker/__shell/* /usr/bin/
