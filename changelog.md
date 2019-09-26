CHANGELOG
=========

The versioning notation below denotes the following:  `[CommandBox Version]/[Image release version]`
## 4.8.0/2.7.2
- Updates CommandBox binary to 4.8.0
- Updates all ACF engines to latest hotfix

## 4.7.0/2.7.1
- Updates Commandbox binary to 4.8.0

## 4.6.0/2.7.0
- Implements the ability to specify a non-root user to run server ( via `USER` environment variable )
- Updates all ACF engines to latest hotfix
- Omits forgebox from module cleanup
- Additional error handling and utilities for manual install
- Adds `fontconfig` for Debian and Alpine to fix PDF generation errors on AdoptOpenJDK base

## 4.6.0/2.6.1
- Updates all ACF engines to latest hotfix
- Updates CommandBox binary to v4.6.0

## 4.5.0/2.6.0
- Updates all java versions to use AdoptOpenJDK builds
- Adds a `javaVersion` environment variable which can be used to customize the startup JRE of the server
- Changes the JRE used for Adobe Coldfusion 2018 images to JRE11

## 4.5.0/2.5.0
- Updates CommandBox binary to v4.5.0

## 4.4.0/2.4.0
- Updates CommandBox binary to v4.4.0
- Adds the `commandbox-dotenv` module in to all base images

## 4.2.0/2.3.0
- Remove no longer needed engine detection from run scripts
- Optimization and reductions to Debian-based image sizes
- Adds additional APK binaries to Alpine images to support PDF/CFDocument rendering

## 4.2.0/2.2.6
- Updates CommandBox binary to v4.2.0

## 4.1.0/2.2.5
- Updates CommandBox binary to v4.1.0


## 4.0.0/2.2.4

- Revises Travis build structure to better support concurrent image builds
- Adds warmed-up engine builds for Alpine images
- Additional optimizations to reduce image size

## 4.0.0/2.2.3

- Temporarily removes support for `HEAP_SIZE` environment variable due to parse failures with env variables in `server.json`

## 4.0.0/2.2.2

- Changes alpine image to use `openjdk:8-alpine`
- Changes image tag in Dockerfile for base Debian image to match official tags on Docker Hub

## 4.0.0/2.2.1

- Adds ability to specify `HEAP_SIZE` environment variable
- Fixes an issue with `cfconfig_` prefixed environment variables failing

## 4.0.0/2.2.0

- Ubuntu base version to use OpenJDK Slim
- Updates to CommandBox v4.0.0
- Changes default CommandBox server engine to Lucee 5

## 3.9.2/2.1.4

- Updates to Commandbox v3.9.2
- Changes Docker secrets placeholder for bash compatibility

## 3.9.1/2.1.3

- Fixes a regression where `SSL_PORT` environment variables were being ignored


## 3.9.0/2.1.2

- Updates to CommandBox v3.9.0
- Fixes server setting argument name

## 3.8.0/2.1.1

- Updates CMD to not persist container runtime settings to server.json

## 3.8.0/2.1.0

- Updates to CommandBox v3.8+
- Adds support for Docker secrets
- Adds casing aliases for environment variables
- Updates runtime output to avoid confusion
- Changes image for alpine build to prevent CommandBox errors when installing dependencies

## 3.7.0/2.0.3

- Updates to CommandBox v3.7+
- Delegates cfconfig environment variables to Commandbox v3.7
