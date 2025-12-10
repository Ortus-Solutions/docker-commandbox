# syntax = docker/dockerfile:1
ARG BASE_IMAGE_ARG
FROM ${BASE_IMAGE_ARG}

LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-commandbox"