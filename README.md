# Official CommandBox Docker Images

[![Docker Image Pulls Badge](https://badgen.net/docker/pulls/ortussolutions/commandbox)](https://hub.docker.com/r/ortussolutions/commandbox/)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/Ortus-Solutions/docker-commandbox/release.yml?branch=development)](https://github.com/Ortus-Solutions/docker-commandbox/actions)
[![GitHub License](https://badgen.net/github/license/Ortus-Solutions/docker-commandbox)](https://github.com/Ortus-Solutions/docker-commandbox?tab=License-1-ov-file#readme)

Welcome to the official Docker images for [CommandBox](https://www.ortussolutions.com/products/commandbox), the BoxLang and CFML development and deployment tool from [Ortus Solutions](https://www.ortussolutions.com/).  These images are designed to provide a lightweight, flexible, and powerful environment for running BoxLang and CFML applications using CommandBox as a powerful servlet container powered by [Undertow](https://undertow.io/).

All images are published to [Docker Hub](https://hub.docker.com/r/ortussolutions/commandbox).

## Table of Contents

- [Features](#features)
- [Available Tags](#available-tags)
  - [Quick Reference](#quick-reference)
  - [Base Images](#base-images-no-engine-pre-installed)
  - [Pre-Built Engine Images](#pre-built-engine-images-warmed-up)
  - [Choosing the Right Tag](#choosing-the-right-tag)
- [Description](#description)
- [Supported Engines](#supported-engines)
- [Supported Architectures and Operating Systems](#supported-architectures-and-operating-systems)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [Port Variables](#port-variables)
- [Load Balancer Configuration](#load-balancer-configuration)
- [HTTP/2 Support](#http2-support)
- [Server Configuration Variables](#server-configuration-variables)
- [Docker Secrets](#docker-secrets)
- [Quick Start Examples](#quick-start-examples)
- [Docker Compose Examples](#docker-compose-examples)
- [Configuration Examples](#configuration-examples)
- [Troubleshooting](#troubleshooting)
- [Best Practices and Customization](#best-practices-and-customization)
- [Security Considerations](#security-considerations)
- [Issues](#issues)
- [License](#license)

## Features

- **Multi-Engine Support**: Run BoxLang Applications or CFML engines, including Lucee and Adobe ColdFusion, in a single container.
- **Customizable**: Easily configure your server environment using `server.json` or environment variables.
- **Pre-Built Engines**: Includes pre-built images with warmed-up engines to reduce startup times.
- **Alpine and UBI9 Variants**: Lightweight Alpine Linux and RHEL Universal Base Image (UBI9) variants for optimized performance and security.
- **Health Checks**: Built-in health checks to ensure your server is running smoothly.
- **Docker Secrets Support**: Use Docker secrets for secure configuration management.
- **Environment Variables**: Extensive support for environment variables to customize your server configuration at runtime.
- **CommandBox Modules**: Includes popular CommandBox modules like `dotenv` and `cfconfig` for enhanced configuration management.
- **Multi-Architecture Support**: Compatible with `linux/amd64`, `linux/arm64`, and `linux/arm/v7` architectures for broad compatibility across different systems.
- **Production Ready**: Optimized for production use with features like HTTP/2 support, secure defaults, and performance enhancements.
- **Finalized Startup Scripts**: Supports multi-stage builds with finalized startup scripts to reduce container startup times by up to 80% and image size by up to 50%.
- **Extensible**: Easily extend the base images with your own custom modules or configurations.
- **Community Support**: Backed by the Ortus Solutions community, with extensive documentation and support available.

## Available Tags

_Note: For references to the specific versions of CommandBox used within image versions, [please see the Changelog](https://github.com/Ortus-Solutions/docker-commandbox/blob/main/changelog.md)._

### Quick Reference

| Tag | Description | Base OS | JDK Version |
|-----|-------------|---------|-------------|
| `:latest` | Latest stable CommandBox | Debian | JDK 11 |
| `:snapshot` | Development/bleeding edge | Debian | JDK 11 |
| `:boxlang` | BoxLang runtime ready | Debian | JDK 21 |
| `:lucee6` | Lucee 6.x warmed up | Debian | JDK 11 |
| `:adobe2025` | Adobe ColdFusion 2025 | Debian | JDK 21 |

### Base Images (No Engine Pre-installed)

#### Standard Debian-based Images

- `:latest` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Dockerfile)) - Latest stable version (JDK 11)
- `:snapshot` - Development/bleeding edge version
- `:boxlang` - BoxLang runtime ready (JDK 21)
- `:lucee6` - Lucee 6.x warmed up (JDK 11)
- `:adobe2025` - Adobe ColdFusion 2025 (JDK 21)
- `:[version]` - Specific tagged version (e.g., `:3.13.4`)
- `:[tag]-snapshot` - Development version of tagged variations

#### JDK/JRE Variants (Debian)

- `:jdk8` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/JDK8.Dockerfile)) - OpenJDK 8
- `:jdk11` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/JDK11.Dockerfile)) - OpenJDK 11 (default)
- `:jre17` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/JRE17.Dockerfile)) - OpenJDK 17 JRE
- `:jdk17` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/JDK17.Dockerfile)) - OpenJDK 17 JDK
- `:jdk21` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/JDK21.Dockerfile)) - OpenJDK 21 JDK
- `:jdk23` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/JDK23.Dockerfile)) - OpenJDK 23 JDK
- `:jdk24` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/JDK24.Dockerfile)) - OpenJDK 24 JDK

#### Alpine Linux Variants

- `:alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Alpine.Dockerfile)) - Alpine Linux (JDK 11)
- `:alpine-jdk8` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Alpine.JDK8.Dockerfile)) - Alpine with JDK 8
- `:alpine-jdk11` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Alpine.JDK11.Dockerfile)) - Alpine with JDK 11
- `:alpine-jre17` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Alpine.JRE17.Dockerfile)) - Alpine with JRE 17
- `:alpine-jdk17` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Alpine.JDK17.Dockerfile)) - Alpine with JDK 17
- `:alpine-jdk21` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Alpine.JDK21.Dockerfile)) - Alpine with JDK 21

#### RHEL Universal Base Image (UBI9) Variants

- `:ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/ubi9.Dockerfile)) - RHEL UBI9 (JDK 11)
- `:ubi9-jdk11` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/ubi9.JDK11.Dockerfile)) - UBI9 with JDK 11
- `:ubi9-jre17` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/ubi9.JRE17.Dockerfile)) - UBI9 with JRE 17
- `:ubi9-jdk17` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/ubi9.JDK17.Dockerfile)) - UBI9 with JDK 17
- `:ubi9-jdk21` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/ubi9.JDK21.Dockerfile)) - UBI9 with JDK 21

### Pre-Built Engine Images (Warmed Up)

These images include pre-downloaded and warmed-up engines to significantly reduce startup times.

#### BoxLang Runtime

- `:boxlang` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/BoxLang.Dockerfile)) - BoxLang on Debian
- `:boxlang-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/BoxLang.Dockerfile)) - BoxLang on Alpine
- `:boxlang-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/BoxLang.Dockerfile)) - BoxLang on UBI9

#### Lucee CFML Engine

**Debian-based Lucee Images:**

- `:lucee4` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Lucee4.Dockerfile)) - Lucee 4.x
- `:lucee5` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Lucee5.Dockerfile)) - Lucee 5.x
- `:lucee6` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Lucee6.Dockerfile)) - Lucee 6.x
- `:lucee-light` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/LuceeLight.Dockerfile)) - Lucee Light (latest)
- `:lucee5-light` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Lucee5Light.Dockerfile)) - Lucee 5.x Light

**Alpine-based Lucee Images:**

- `:lucee5-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Lucee5.Dockerfile)) - Lucee 5.x on Alpine
- `:lucee6-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Lucee6.Dockerfile)) - Lucee 6.x on Alpine
- `:lucee-light-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/LuceeLight.Dockerfile)) - Lucee Light on Alpine
- `:lucee5-light-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Lucee5Light.Dockerfile)) - Lucee 5.x Light on Alpine

**UBI9-based Lucee Images:**

- `:lucee5-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Lucee5.Dockerfile)) - Lucee 5.x on UBI9
- `:lucee6-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Lucee6.Dockerfile)) - Lucee 6.x on UBI9
- `:lucee-light-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/LuceeLight.Dockerfile)) - Lucee Light on UBI9
- `:lucee5-light-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Lucee5Light.Dockerfile)) - Lucee 5.x Light on UBI9

#### Adobe ColdFusion Engine

**Debian-based Adobe Images:**

- `:adobe11` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe11.Dockerfile)) - Adobe ColdFusion 11
- `:adobe2016` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2016.Dockerfile)) - Adobe ColdFusion 2016
- `:adobe2018` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2018.Dockerfile)) - Adobe ColdFusion 2018
- `:adobe2021` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2021.Dockerfile)) - Adobe ColdFusion 2021
- `:adobe2023` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2023.Dockerfile)) - Adobe ColdFusion 2023
- `:adobe2025` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2025.Dockerfile)) - Adobe ColdFusion 2025

**Alpine-based Adobe Images:**

- `:adobe2018-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Adobe2018.Dockerfile)) - Adobe ColdFusion 2018 on Alpine
- `:adobe2021-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Adobe2021.Dockerfile)) - Adobe ColdFusion 2021 on Alpine
- `:adobe2023-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Adobe2023.Dockerfile)) - Adobe ColdFusion 2023 on Alpine
- `:adobe2025-alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Adobe2025.Dockerfile)) - Adobe ColdFusion 2025 on Alpine

**UBI9-based Adobe Images:**

- `:adobe2018-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Adobe2018.Dockerfile)) - Adobe ColdFusion 2018 on UBI9
- `:adobe2021-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Adobe2021.Dockerfile)) - Adobe ColdFusion 2021 on UBI9
- `:adobe2023-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Adobe2023.Dockerfile)) - Adobe ColdFusion 2023 on UBI9
- `:adobe2025-ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Adobe2025.Dockerfile)) - Adobe ColdFusion 2025 on UBI9

### Choosing the Right Tag

- **For BoxLang applications**: Use `:boxlang` variants
- **For CFML Warmed Up Engines**: Use `:lucee6` or `:adobe2025` for the latest engines
- **For production**: Use specific engine tags with your preferred base OS
- **For smaller images**: Use `-alpine` variants
- **For enterprise/RHEL environments**: Use `-ubi9` variants
- **For development**: Use `:snapshot` for bleeding edge features

_**Note**: The `:latest` tag currently uses OpenJDK11, as do most pre-built engine images. BoxLang and Adobe2025 images use JDK21. If you require specific JDK versions, use the appropriate JDK variant tags._

## Description

CommandBox is a powerful Java servlet container powered by [Undertow](https://undertow.io/), which allows you to run BoxLang and/or CFML applications in a lightweight, flexible, and production-ready environment.  It is the de-facto standard of deployment for BoxLang web applications.  It also supports multiple CFML engines, including Lucee and Adobe ColdFusion, and provides a rich set of features for application development and deployment.  For more information on how to leverage CommandBox in developing and deploying your applications, see the [official documentation](https://commandbox.ortusbooks.com/).

In addition the CommandBox modules of [`dotenv`](https://www.forgebox.io/view/commandbox-dotenv) and [`cfconfig`](https://cfconfig.ortusbooks.com/) are included in these pre-built images, which allow you to leverage additional runtime environmental and server configuration options.

## Supported Engines

- [BoxLang](https://boxlang.io/) - BoxLang is a modern JVM programming language that is designed to be a powerful, expressive, and easy-to-use language for building web applications, serverless, CLI tools and more.
- Lucee CFML Engine:  5+
- Adobe ColdFusion 2018+

You may also [specify a custom WAR for deployment](https://commandbox.ortusbooks.com/embedded-server/multi-engine-support#war-support), using the `server.json` configuration.

## Supported Architectures and Operating Systems

All Debian-based images currently support `linux/amd64`, `linux/arm64` and `linux/arm/v7` architecture. Alpine builds are currently only supported on `linux/amd64` and `linux/arm64` architectures.  The UBI9 builds are supported on `linux/amd64` and `linux/arm64` architectures.

## Usage

This section assumes you are using the [Official Docker Image](https://hub.docker.com/r/ortussolutions/commandbox/)

By default, the directory `/app` in the container is mapped as the Commandbox home.  To deploy a new application, first pull the image:

```
docker pull ortussolutions/commandbox
```

Then, from the root of your project, start with

```
docker run -p 8080:8080 -p 8443:8443 -v "/path/to/your/app:/app" ortussolutions/commandbox
```

By default the process ports of the container are `8080` (insecure) and `8443` (secure - if enabled in your `server.json`) so, once the container comes online, you may access your application via browser using the applicable port (which we explicitly exposed for external access in the `run` command above).  You may also specify different port arguments in your `run` command to assign what is to be used in the container and exposed.  This prevents conflicts with other instances in the Docker machine using those ports:

```
docker run -p 80:80 -p 443:443 -e "PORT=80" -e "SSL_PORT=443" -v "/path/to/your/app:/app" ortussolutions/commandbox
```

## Environment Variables

The CommandBox Docker image supports the use of environmental variables for the configuration of your servers.  Specifically, the image includes the [`cfconfig` CommandBox module](https://www.forgebox.io/view/commandbox-cfconfig), which allows you to provide custom settings for your engine, including the admin password.

## Port Variables

- `$PORT` - The port which your server should start on.  The default is `8080`.
- `$SSL_PORT` - If applicable, the ssl port used by your server The default is `8443`.

## Load Balancer Configuration

In order to use the [multi-site features](https://commandbox.ortusbooks.com/embedded-server/multi-site-support) of CommandBox v6 and above, if your multi-site setup is domain-aware, you will need to set [the environment variable](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/proxy-ip) `BOX_SERVER_WEB_useProxyForwardedIP=true`.  Note, though, that doing so will open your container up to threat vectors by providing visitors with the ability to circumvent:

- Internal-only host matching
- IP restrictions on admin blocking

As well as potentially allowing the spoofing of client certs and/or SSL redirects/validation. Because of this, if you choose to enable this setting, you should take care to ensure that your containers are _only publicly accessible via the load balancer_ and exposed container ports on the Docker host are not publicly available.  Once this setting is enabled, however, headers such as `X-Forwarded-Host` sent by the upstream load balancer will be honored when service multi-site traffic.

## HTTP/2 Support

As of Commandbox `v5.3.0`, all CommandBox servers have HTTP/2 enabled by default. For browser support of this protocol, you will need to enable SSL and provide a certificate.

## Server Configuration Variables

The following environment variables may be provided to modify your runtime server configuration. Please note that environment variables are case sensitive and, while some lower/upper case aliases are accounted for, you should use consistent casing in order for these variables to take effect.

- `BOX_SERVER_APP_SERVERHOMEDIRECTORY` - When provided, a custom path to your server home directory will be assigned. By default, this path is set as `${LIB_DIR}/serverHome`, which resolves to `/usr/local/lib/serverHome` in most builds. The Alpine-based builds will default to `/usr/lib/serverHome`. (_Note: You may also provide this variable in your app's customized `server.json` file_)
- `APP_DIR` - Application directory (web root). By default, this is `/app`. If you are deploying an application with mappings outside of the root, you would want to provide this environment variable to point to the webroot (e.g. `/app/wwwroot`)
- `USER` - When provided the server process will run under the provided user account name
- `USER_ID` - Numeric. When provided in conjunction with a `USER` environment variable, the UID of the user will be assigned this number. This can be useful for ensuring permissions of mounted volumes and files
- `cfconfig_[engine setting]` - Any environment variable provided which includes the `cfconfig_` prefix will be determined to be a `cfconfig` setting and the value after the prefix is presumed to be the setting name.
- `BOX_SERVER_CFCONFIGFILE` - A `cfconfig`-compatible JSON file may be provided with this environment variable. The file will be loaded and applied to your server. If an `adminPassword` key exists, it will be applied as the Server and Web context passwords for Lucee engines. You may instead add a `.cfconfig.json` file to the root of the `APP_DIR` and it will be picked up automatically.
- `BOX_SERVER_APP_CFENGINE` - Using the `server.json` syntax, allows you to specify the CFML engine for your container (e.g. `lucee@5`). Defaults to the CommandBox default (currently `lucee@4.5`)
- `BOX_SERVER_RUNWAR_CONSOLE_APPENDERLAYOUT` - When setting this to `JSONTemplateLayout`, the log output of the container will be in [`ndjson`](http://ndjson.org/). For more information on this setting, please see [the CommandBox documentation on customizing log layouts](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/console-log-layout#customize-layout)
- `FINALIZE_STARTUP` - When provided a final startup script will be generated, which will be considered authoritative the next time the container/image starts. The caveat to this, however, is that the finalized startup script will bypass the evaluation checks for all of the other environment variables in this list as those values will be explicitly exported in the startup file.
- `BOX_SERVER_PROFILE` - When set, this will be applied as the runtime [CommandBox server profile](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/server-profiles). By default, CommandBox will set this value to the `production` mode, since the container server binds to all interfaces on `0.0.0.0`. If you wish a lower level of security, you will need to provide this variable or set it in your `server.json` file.
- `BOX_SERVER_WEB_REWRITES_ENABLE` - A boolean value, specifying whether URL rewrites will be enabled/disabled on the server. Setting this environment variable will overwrite any settings within the app's `server.json` file.
- `CFPM_INSTALL` and `CFPM_UNINSTALL` - Supported for Adobe Coldfusion 2021+ engines. When provided as a delimited list of [Coldfusion Package Manager](https://helpx.adobe.com/coldfusion/using/coldfusion-package-manager.html) packages, these will be installed (or uninstalled, respectively), prior to the server start. A warmed-up server is required to use these variables.
- `BOX_INSTALL`/`box_install` - When set to true, the `box install` command will be run before the server is started to ensure any dependencies configured in your `box.json` file are installed

### Docker Runtime Variables

- `$HEALTHCHECK_URI` - Specifies the URI endpoint for container [health checks](https://docs.docker.com/engine/reference/builder/#healthcheck). By default, this defaults to `http://127.0.0.1:${PORT}/` at 20 second intervals, a timeout of 30 seconds, with 15 retries before the container is marked as failed. _Note: Since the interval, timeout, and retry settings cannot be set dynamically, if you need to adjust these, you will need to build from a Dockerfile which provides a new [`HEALTHCHECK` command](https://docs.docker.com/engine/reference/builder/#healthcheck)_

### Deprecated Environment Variables

The following variables are still supported, however they are deprecated and support will be removed in the next major release version of the image:

- `SERVER_HOME_DIRECTORY` - Use `BOX_SERVER_APP_SERVERHOMEDIRECTORY` instead
- `CFCONFIG` and `cfconfigfile` - Use `BOX_SERVER_CFCONFIGFILE` instead
- `CFENGINE` - Use `BOX_SERVER_APP_CFENGINE` instead
- `HEADLESS=true` - Use `BOX_SERVER_PROFILE=production` instead
- `SERVER_PROFILE` - Use `BOX_SERVER_PROFILE` instead
- `URL_REWRITES`/`url_rewrites` - Use `BOX_SERVER_WEB_REWRITES_ENABLE` instead

## Docker Secrets

[Docker secrets](https://docs.docker.com/engine/swarm/secrets/) can use two storage mechanisms:

- Secret values stored as files on the host (non-swarm mode).
- `docker secret`-managed key/value pairs (swarm mode).

Secret expansion can be accomplished by one of two mechanisms ( or both ):

### `<<SECRET:*>>` Prefix

To use secrets as variables in this image, a placeholder is specified (e.g., `<<SECRET:test_docker_secret>>`) as the variable's value. At run-time, the environment variable's value is replaced with the secret.

Example with a secret using host file storage:

```yml
version: '3.1'

services:

  sut:
    environment:
      - IMAGE_TESTING_IN_PROGRESS=true
      #- ENV_SECRETS_DEBUG # uncomment to debug the placeholder replacements
      # this is a placeholder that will be replaced at runtime with the secret value
      - TEST_DOCKER_SECRET=<<SECRET:test_docker_secret>>
    ...

secrets:
  test_docker_secret:
    # this is the file containing the secret value
    file: ./build/tests/secrets/test_docker_secret
```

### `_FILE` Suffix conventions

When any environment variable is suffixed with `_FILE`, the right-hand assignment will be loaded and expanded as the environment variable prior to the suffix.  The most common use-case for this is in sourcing Docker secrets, however it may also be used to source runtime-mounted files as variables.

For example the variable `REINIT_PASSWORD_FILE=/run/secrets/reinit_password` would source the contents of the right-hand file path in as the `REINIT_PASSWORD` environment variable.


## Quick Start Examples

### BoxLang Application

```bash
# Pull and run BoxLang image
docker run -p 8080:8080 -v "$(pwd):/app" ortussolutions/commandbox:boxlang
```

### Lucee Application with Custom Admin Password

```bash
docker run -p 8080:8080 \
  -e "cfconfig_adminPassword=mySecretPassword" \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:lucee6
```

### Adobe ColdFusion with SSL

```bash
docker run -p 8080:8080 -p 8443:8443 \
  -e "BOX_SERVER_WEB_REWRITES_ENABLE=true" \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:adobe2025
```

### Development with Auto-reload

```bash
docker run -p 8080:8080 \
  -e "BOX_SERVER_PROFILE=development" \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:snapshot
```

## Docker Compose Examples

### Basic Application Stack

```yaml
version: '3.8'
services:
  app:
    image: ortussolutions/commandbox:lucee6
    ports:
      - "8080:8080"
    volumes:
      - .:/app
    environment:
      - cfconfig_adminPassword=admin123
      - BOX_SERVER_WEB_REWRITES_ENABLE=true
```

### Multi-Service Application with Database

```yaml
version: '3.8'
services:
  app:
    image: ortussolutions/commandbox:adobe2025
    ports:
      - "8080:8080"
    volumes:
      - .:/app
    environment:
      - cfconfig_adminPassword=admin123
      - BOX_SERVER_PROFILE=production
    depends_on:
      - db

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: myapp
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppass
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```

## Configuration Examples

### Server.json Configuration

Create a `server.json` in your application root for advanced configuration:

```json
{
  "app": {
    "cfengine": "boxlang@1.0.0"
  },
  "web": {
    "http": {
      "port": 8080
    },
    "ssl": {
      "enable": true,
      "port": 8443
    },
    "rewrites": {
      "enable": true
    }
  },
  "runwar": {
    "args": "--enable-http2"
  }
}
```

### CFConfig Integration

Create a `.cfconfig.json` file for engine-specific settings:

```json
{
  "adminPassword": "secure123",
  "requestTimeoutEnabled": true,
  "requestTimeout": "0,0,5,0",
  "datasources": {
    "myDS": {
      "class": "com.mysql.cj.jdbc.Driver",
      "connectionString": "jdbc:mysql://db:3306/myapp",
      "username": "appuser",
      "password": "apppass"
    }
  }
}
```

### Environment File (.env)

Use a `.env` file for easier environment management:

```env
# Server Configuration
PORT=8080
SSL_PORT=8443
BOX_SERVER_PROFILE=production

# Engine Configuration
BOX_SERVER_APP_CFENGINE=lucee@6

# CFConfig Settings
cfconfig_adminPassword=mySecretPassword
cfconfig_requestTimeoutEnabled=true

# Application Settings
APP_DIR=/app
BOX_SERVER_WEB_REWRITES_ENABLE=true
```

## Troubleshooting

### Common Issues

#### Container Exits Immediately

**Problem**: Container starts and immediately exits.

**Solutions**:

- Check if port 8080 is already in use: `docker run -p 8081:8080 ...`
- Verify your application has an `index.cfm` or `index.bxm` file
- Check container logs: `docker logs <container_id>`

#### Permission Denied Errors

**Problem**: Application files cannot be read or written.

**Solutions**:

- Set the correct user: `-e "USER_ID=$(id -u)" -e "USER=$(whoami)"`
- Check file permissions on the host system
- Use absolute paths for volume mounts

#### Engine Download Failures

**Problem**: CFML engine fails to download.

**Solutions**:

- Use pre-warmed images (e.g., `:lucee6`, `:adobe2025`)
- Check internet connectivity from container
- Try a different engine version: `-e "BOX_SERVER_APP_CFENGINE=lucee@5.4.6"`

#### Memory Issues

**Problem**: Application runs out of memory.

**Solutions**:

- Increase Docker memory limits: `docker run -m 2g ...`
- Use JVM arguments: `-e "JAVA_OPTS=-Xmx2g -Xms512m"`
- Monitor memory usage: `docker stats <container_id>`

### Debugging Commands

```bash
# View container logs
docker logs -f <container_id>

# Access container shell
docker exec -it <container_id> /bin/bash

# Check Java processes
docker exec <container_id> ps aux | grep java

# View CommandBox server info
docker exec <container_id> box server info

# Check disk usage
docker exec <container_id> df -h
```

### Performance Tuning

#### JVM Settings

```bash
# Optimize JVM for container environments
docker run -p 8080:8080 \
  -e "JAVA_OPTS=-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0" \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:lucee6
```

#### CommandBox Settings

```bash
# Enable performance optimizations
docker run -p 8080:8080 \
  -e "BOX_SERVER_PROFILE=production" \
  -e "BOX_SERVER_RUNWAR_ARGS=--enable-http2 --nio-enable" \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:adobe2025
```

## Security Considerations

### Production Deployment

When deploying CommandBox containers in production, consider the following security best practices:

#### Network Security

```bash
# Use specific network configurations
docker network create --driver bridge commandbox-net
docker run --network commandbox-net -p 8080:8080 ortussolutions/commandbox:adobe2025
```

#### User Management

```bash
# Run as non-root user
docker run -p 8080:8080 \
  -e "USER=appuser" \
  -e "USER_ID=1000" \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:lucee6
```

#### Environment Variables and Secrets

```yaml
# Use Docker secrets for sensitive data
version: '3.8'
services:
  app:
    image: ortussolutions/commandbox:adobe2025
    secrets:
      - admin_password
      - db_password
    environment:
      - cfconfig_adminPassword_FILE=/run/secrets/admin_password
      - DB_PASSWORD_FILE=/run/secrets/db_password

secrets:
  admin_password:
    file: ./secrets/admin_password.txt
  db_password:
    file: ./secrets/db_password.txt
```

#### Server Profile Settings

```bash
# Use production profile for security
docker run -p 8080:8080 \
  -e "BOX_SERVER_PROFILE=production" \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:lucee6
```

#### Health Check Security

```dockerfile
# Custom health check for security
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

### Container Hardening

#### Read-Only File System

```bash
# Run with read-only file system
docker run -p 8080:8080 \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /usr/local/lib/serverHome/logs \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:alpine
```

#### Resource Limits

```bash
# Set resource limits
docker run -p 8080:8080 \
  --memory=2g \
  --cpus=2 \
  --pids-limit=100 \
  -v "$(pwd):/app" \
  ortussolutions/commandbox:lucee6
```

#### Security Context

```yaml
# Kubernetes security context
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
      containers:
      - name: commandbox
        image: ortussolutions/commandbox:adobe2025
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
            - ALL
```

## Best Practices and Customization

### Customizing Images

To create your own, customized Docker image, use [our Dockerfile repository](https://github.com/Ortus-Solutions/docker-commandbox/tree/development/builds) as a reference to begin your customizations. You can extend any of the base images and add your own additional functionality or modules. For example, to install the [Ortus Redis extension for Lucee](https://www.ortussolutions.com/products/redis-lucee):

```dockerfile
FROM ortussolutions/commandbox:lucee6

ARG REDIS_EMAIL
ARG REDIS_LICENSE_KEY
ARG REDIS_ACTIVATION_CODE

# Install the Ortus Redis cache extension from Forgebox
RUN box install 5C558CC6-1E67-4776-96A60F9726D580F1

# Scope in our args for extension activation
ENV REDIS_EXTENSION_EMAIL=$REDIS_EMAIL
ENV REDIS_EXTENSION_LICENSE_KEY=$REDIS_LICENSE_KEY
ENV REDIS_EXTENSION_ACTIVATION_CODE=$REDIS_ACTIVATION_CODE
ENV REDIS_EXTENSION_SERVER_TYPE=Production

# WARM UP THE SERVER WITH THE NEW EXTENSION
RUN ${BUILD_DIR}/util/warmup-server.sh
```

We recommend using the pre-tagged images as your base, rather than starting from scratch.

### Optimizing Startup Times

Because, with the exception of the CommandBox default engine of Lucee 5, the CFML server engines are downloaded and installed at container runtime. This can result in significant startup time increases (even with Lucee 5 already downloaded in the base image, there is a time penalty for a "cold start"). It is recommended that builds for production use employ an engine-specific variation for the build, which ensures the server is downloaded, in place, and warmed up on container start.

For a basic example, the following will suffice:

```dockerfile
FROM ortussolutions/commandbox:lucee6

# Copy application files to root
COPY ./ ${APP_DIR}/
```

In many cases, you will have tier-specific builds, with custom configuration options. The following employs a `build` directory, which includes additional configuration files for tier-based deployments:

```dockerfile
FROM ortussolutions/commandbox:lucee6

ARG CI_ENVIRONMENT_NAME

# Copy application files to root
COPY ./ ${APP_DIR}/

# Copy tier-only files over
COPY ./build/env/${CI_ENVIRONMENT_NAME}/tier/ ${APP_DIR}/

# Install our box.json dependencies
RUN cd ${APP_DIR} && box install

# Warm up and validate our server
RUN ${APP_DIR}/build/env/setup-env.sh

# Remove our build directory from our deployable image
RUN rm -rf ${APP_DIR}/build

# Set our healthcheck to a non-framework route - in this case we only need to know that CFML pages are being served
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/config/Routes.cfm"
```

In the above case, the `setup-env.sh` file might perform an additional server warmup and validation, where in the former case, the server was previously warmed up when the image was built.

Once your customized `Dockerfile` has has been built, you can run the generated image directly, or publish it to a [private registry](https://docs.docker.com/registry/)

### Multi-Stage Builds

As of v3.0.0 of the image you can create multi-stage builds which include only a shell script to start the server, the RunWar servlet container, and the application/engine. _This build is finalized, however, so the startup script will bypass all environmental and server evaluation in favor of the variables provided in the generated shell script._ This means that you will need to provide all secrets and variables needed by your server and CFConfig files during the initial build phase, as the `.env` and `.cfconfig.json` files will not be in play during the server startup.

A finalized image reduces container startup times by up to 80% and reduces the final image size by up to 50%. Multi-stage builds are ideal for creating production images. The environment variable `FINALIZE_STARTUP`, when provided, will only generate the startup script. The script written is considered authoritative and will be used on the next container start.

To leverage this with a multi-stage build:

```dockerfile
FROM ortussolutions/commandbox:lucee6 as workbench

# Generate the startup script only
ENV FINALIZE_STARTUP true
RUN $BUILD_DIR/run.sh

# Eclipse Temurin Focal image is the smallest OpenJDK image on that the same kernel used in the base image.
# For most apps, this should work to run your applications
FROM eclipse-temurin:11-jre-jammy as app

# COPY our generated files
COPY --from=workbench /app /app
COPY --from=workbench /usr/local/lib/serverHome /usr/local/lib/serverHome

RUN mkdir -p /usr/local/lib/CommandBox/lib

COPY --from=workbench /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar
COPY --from=workbench /usr/local/bin/startup-final.sh /usr/local/bin/run.sh

# Restore working directory environment
ENV APP_DIR /app
WORKDIR $APP_DIR

# Restore the healthcheck, since that doesn't transfer from the first stage
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/"
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

CMD /usr/local/bin/run.sh
```

### Single-Stage With Script Finalization

You may also create this finalized startup script in a single-stage build:

```dockerfile
FROM ortussolutions/commandbox:lucee6

# Generate the finalized startup script and exit
RUN export FINALIZE_STARTUP=true;$BUILD_DIR/run.sh;unset FINALIZE_STARTUP
```

This created image will contain the authoritative script with its runtime benefits and caveats (see above). Unlike the multi-stage build above, however, secret expansion will take place prior to image start, with the caveat that _any environment variables in existence when the finalized script was generated will overwrite the runtime-provided variables or secrets_.

## Issues

Please submit issues to our repository: [https://github.com/Ortus-Solutions/docker-commandbox/issues](https://github.com/Ortus-Solutions/docker-commandbox/issues)

## License

This project is licensed under the Apache License, Version 2.0. You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

---

## HONOR GOES TO GOD ABOVE ALL

Because of His grace, this project exists. If you don't like this, then don't read it, it's not for you.

> "Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
> By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
> And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
> And patience, experience; and experience, hope:
> And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the
> Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD

> "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
