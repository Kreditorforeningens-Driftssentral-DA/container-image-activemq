# ACTIVEMQ

![Public Image Builds](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-activemq/workflows/Packer%20Public/badge.svg?branch=main)

Container image for ActiveMQ (Classic) | See on [Docker Hub](https://hub.docker.com/r/kdsda/activemq)

## HOW TO USE THIS IMAGE
This image will start an activemq instance, listening on ports 61616 (openwire) & 8161 (admin/hawtio)

#### CREDENTIALS
Default credentials (web/queue):
  * Username: system
  * Password: manager

#### STORAGE BACKEND
The container supports local kaha backend & external postgres backend.

This is configured using the environment variable '**BACKEND**':
  * **unset** (default): The container will default to local storage (kaha), if this variable is not set
  * **postgres**: The backend will try to connect to a postgres database. You can the override the connection defaults using the following environment variables:
      * **POSTGRES_HOST** (postgres)
      * **POSTGRES_PORT** (5432)
      * **POSTGRES_DATABASE** (postgres)
      * **POSTGRES_USERNAME** (postgres)
      * **POSTGRES_PASSWORD** (postgres)
      * **POSTGRES_INIT** (false)

## LINKS
  * https://activemq.apache.org/web-console
