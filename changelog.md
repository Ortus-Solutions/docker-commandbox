CHANGELOG
=========

The versioning notation below denotes the following:  `[CommandBox Version]/[Image release version]`

## 3.9.2/2.1.3

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
