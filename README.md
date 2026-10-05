# Official CommandBox Docker Images

[![Docker Image Pulls Badge](https://badgen.net/docker/pulls/ortussolutions/commandbox)](https://hub.docker.com/r/ortussolutions/commandbox/)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/Ortus-Solutions/docker-commandbox/release.yml?branch=development)](https://github.com/Ortus-Solutions/docker-commandbox/actions)
![GitHub License](https://badgen.net/github/license/Ortus-Solutions/docker-commandbox)

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
- **Alpine and UBI10 Variants**: Lightweight Alpine Linux and RHEL Universal Base Image (UBI10) variants for optimized performance and security.
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

_Note: Image release versions are distinct from the CommandBox version packaged within each image._

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

- `:latest` - Latest stable version (JDK 11)
- `:snapshot` - Development/bleeding edge version
- `:boxlang` - BoxLang runtime ready (JDK 21)
- `:lucee6` - Lucee 6.x warmed up (JDK 11)
- `:adobe2025` - Adobe ColdFusion 2025 (JDK 21)
- `:[version]` - Specific tagged version (e.g., `:3.13.8`)
- `:[tag]-snapshot` - Development version of tagged variations

#### JDK/JRE Variants (Debian)

- `:jdk8` - OpenJDK 8
- `:jdk11` - OpenJDK 11 (default)
- `:jre17` - OpenJDK 17 JRE
- `:jdk17` - OpenJDK 17 JDK
- `:jdk21` - OpenJDK 21 JDK
- `:jdk23` - OpenJDK 23 JDK
- `:jdk24` - OpenJDK 24 JDK

#### Alpine Linux Variants

- `:alpine` - Alpine Linux (JDK 11)
- `:alpine-jdk8` - Alpine with JDK 8
- `:alpine-jdk11` - Alpine with JDK 11
- `:alpine-jre17` - Alpine with JRE 17
- `:alpine-jdk17` - Alpine with JDK 17
- `:alpine-jdk21` - Alpine with JDK 21

#### RHEL Universal Base Image (UBI10) Variants

- `:UBI10` - RHEL UBI10 (JDK 11)
- `:UBI10-jdk11` - UBI10 with JDK 11
- `:UBI10-jre17` - UBI10 with JRE 17
- `:UBI10-jdk17` - UBI10 with JDK 17
- `:UBI10-jdk21` - UBI10 with JDK 21

### Pre-Built Engine Images (Warmed Up)

These images include pre-downloaded and warmed-up engines to significantly reduce startup times.

#### BoxLang Runtime

- `:boxlang` - BoxLang on Debian
- `:boxlang-alpine` - BoxLang on Alpine
- `:boxlang-rhel` - BoxLang on UBI10

#### Lucee CFML Engine

**Debian-based Lucee Images:**

- `:lucee4` - Lucee 4.x
- `:lucee5` - Lucee 5.x
- `:lucee6` - Lucee 6.x
- `:lucee-light` - Lucee Light (latest)
- `:lucee5-light` - Lucee 5.x Light

**Alpine-based Lucee Images:**

- `:lucee5-alpine` - Lucee 5.x on Alpine
- `:lucee6-alpine` - Lucee 6.x on Alpine
- `:lucee-light-alpine` - Lucee Light on Alpine
- `:lucee5-light-alpine` - Lucee 5.x Light on Alpine

**UBI10-based Lucee Images:**

- `:lucee5-rhel` - Lucee 5.x on UBI10
- `:lucee6-rhel` - Lucee 6.x on UBI10
- `:lucee-light-rhel` - Lucee Light on UBI10
- `:lucee5-light-rhel` - Lucee 5.x Light on UBI10

#### Adobe ColdFusion Engine

**Debian-based Adobe Images:**

- `:adobe11` - Adobe ColdFusion 11
- `:adobe2016` - Adobe ColdFusion 2016
- `:adobe2018` - Adobe ColdFusion 2018
- `:adobe2021` - Adobe ColdFusion 2021
- `:adobe2023` - Adobe ColdFusion 2023
- `:adobe2025` - Adobe ColdFusion 2025

**Alpine-based Adobe Images:**

- `:adobe2018-alpine` - Adobe ColdFusion 2018 on Alpine
- `:adobe2021-alpine` - Adobe ColdFusion 2021 on Alpine
- `:adobe2023-alpine` - Adobe ColdFusion 2023 on Alpine
- `:adobe2025-alpine` - Adobe ColdFusion 2025 on Alpine

**UBI10-based Adobe Images:**

- `:adobe2018-rhel` - Adobe ColdFusion 2018 on UBI10
- `:adobe2021-rhel` - Adobe ColdFusion 2021 on UBI10
- `:adobe2023-rhel` - Adobe ColdFusion 2023 on UBI10
- `:adobe2025-rhel` - Adobe ColdFusion 2025 on UBI10

### Choosing the Right Tag

- **For BoxLang applications**: Use `:boxlang` variants
- **For CFML Warmed Up Engines**: Use `:lucee6` or `:adobe2025` for the latest engines
- **For production**: Use specific engine tags with your preferred base OS
- **For smaller images**: Use `-alpine` variants
- **For enterprise/RHEL environments**: Use `-rhel` variants
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

All Debian-based images currently support `linux/amd64`, `linux/arm64` and `linux/arm/v7` architecture. Alpine builds are currently only supported on `linux/amd64` and `linux/arm64` architectures.  The UBI10 builds are supported on `linux/amd64` and `linux/arm64` architectures.

## Usage

This section assumes you are using the [Official Docker Image](https://hub.docker.com/r/ortussolutions/commandbox/)

By default, the application webroot is `/srv/app` in the container. CommandBox's package home is `/opt/commandbox`. To deploy a new application, first pull the image:

```
docker pull ortussolutions/commandbox
```

Then, from the root of your project, start with

```
docker run -p 8080:8080 -p 8443:8443 -v "/path/to/your/app:/srv/app" ortussolutions/commandbox
```

By default the process ports of the container are `8080` (insecure) and `8443` (secure - if enabled in your `server.json`) so, once the container comes online, you may access your application via browser using the applicable port (which we explicitly exposed for external access in the `run` command above).  You may also specify different port arguments in your `run` command to assign what is to be used in the container and exposed.  This prevents conflicts with other instances in the Docker machine using those ports:

```
docker run -p 80:8080 -p 443:8443 -v "/path/to/your/app:/srv/app" ortussolutions/commandbox
```

## Filesystem Migration

This major release uses the same default locations on Debian, Alpine, and RHEL:

| Setting | Default location |
| --- | --- |
| `APP_DIR` | `/srv/app` |
| `BIN_DIR` | `/opt/bin` |
| `LIB_DIR` | `/opt/lib` |
| `BUILD_DIR` | `/opt/build` |
| `COMMANDBOX_HOME` | `/opt/commandbox` |
| `BOXLANG_HOME` and `BOXLANG_INSTALL_HOME` | `/opt/boxlang` |
| Server home | `/opt/lib/serverHome` |
| `HOME` | `/home/commandbox` |
| `STARTUP_DIR` | `/opt/commandbox/run` |

OS-managed packages and the inherited Java installation retain their upstream locations. CommandBox and engine-managed caches, logs, and configuration retain their internal structure within the new package homes.

Before upgrading, update application volume destinations from `/app` to `/srv/app`, build-script mounts to `/opt/build`, and engine-state mounts to `/opt/lib/serverHome`. Update hardcoded `COPY`, `WORKDIR`, startup-script, and package-home paths in derived images. Prefer the existing path variables where possible. Rebuild derived images against the new major-version bases.

There are no compatibility aliases for the old application, build, or package-home defaults, and startup does not move existing data. Back up persisted state and explicitly copy or remount it at the new locations before upgrading. Explicit `APP_DIR` and `BOX_SERVER_APP_SERVERHOMEDIRECTORY` overrides remain supported; mount the application and server state at those chosen paths. Changing an installation-path variable at runtime does not relocate packages already baked into an image.

### Runtime User

All images run as `commandbox:runwar` with UID/GID `1000:1000` by default. The `USER` and `USER_ID` environment variables no longer select an identity. Use Docker `--user`, Compose `user`, or your orchestrator's security context instead. Startup never creates accounts, switches users, moves package homes, or changes ownership.

Application files, `HOME`, CommandBox and BoxLang homes, server state, and `STARTUP_DIR` are writable by the shared `runwar` group. Writable directories inherit GID `1000`, and startup uses `umask 0002`. `/opt/bin`, `/opt/build`, and the inherited Java installation remain root-owned and non-writable. BoxLang's installed CLI and writable state currently share `/opt/boxlang`.

An alternate numeric UID does not need a passwd entry, but must retain access to shared GID `1000`:

```bash
docker run --user 1002:1000 -p 8080:8080 ortussolutions/commandbox:lucee6
docker run --user 1002:1002 --group-add 1000 -p 8080:8080 ortussolutions/commandbox:lucee6
```

```yaml
services:
  app:
    image: ortussolutions/commandbox:lucee6
    user: "1002:1002"
    group_add:
      - "1000"
```

Bind mounts replace image permissions. Prepare them on the host so the selected UID or GID `1000` can read and write the application and any custom server home. Alternatively, use a matching host UID with `--user "$(id -u):1000"`. Fresh named volumes inherit the image's permissions; reused volumes do not. Back up and explicitly update ownership/group access on existing volumes before upgrading. Startup fails with a permission diagnostic instead of modifying mounted ownership.

Generated scripts and finalized metadata now live in `STARTUP_DIR`, not `BIN_DIR`. Rebuild finalized images against this release; preserve both `startup-final.sh` and `startup-final.env` when copying finalized artifacts.

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

- `BOX_SERVER_APP_SERVERHOMEDIRECTORY` - When provided, a custom path to your server home directory will be assigned. The default is `${LIB_DIR}/serverHome`, resolving to `/opt/lib/serverHome` on every distribution. An explicit environment value takes precedence over `app.serverHomeDirectory` in `server.json`; relative paths are resolved from `APP_DIR`.
- `APP_DIR` - Application directory (web root). By default, this is `/srv/app`. If you are deploying an application with mappings outside of the root, provide this variable to point to the webroot (e.g. `/srv/app/wwwroot`).
- `STARTUP_DIR` - Writable directory for generated scripts and finalized metadata. Defaults to `/opt/commandbox/run`; a custom location must be writable by the container identity.
- `cfconfig_[engine setting]` - Any environment variable provided which includes the `cfconfig_` prefix will be determined to be a `cfconfig` setting and the value after the prefix is presumed to be the setting name.
- `BOX_SERVER_CFCONFIGFILE` - A `cfconfig`-compatible JSON file may be provided with this environment variable. The file will be loaded and applied to your server. If an `adminPassword` key exists, it will be applied as the Server and Web context passwords for Lucee engines. You may instead add a `.cfconfig.json` file to the root of the `APP_DIR` and it will be picked up automatically.
- `BOX_SERVER_APP_CFENGINE` - Using the `server.json` syntax, allows you to specify the CFML engine for your container (e.g. `lucee@5`). Defaults to the CommandBox default (currently `lucee@4.5`)
- `BOX_SERVER_RUNWAR_CONSOLE_APPENDERLAYOUT` - When setting this to `JSONTemplateLayout`, the log output of the container will be in [`ndjson`](http://ndjson.org/). For more information on this setting, please see [the CommandBox documentation on customizing log layouts](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/console-log-layout#customize-layout)
- `FINALIZE_STARTUP` - When provided, generates `${STARTUP_DIR}/startup-final.sh`, which is authoritative on subsequent startup. `${STARTUP_DIR}/startup-final.env` records its baked server home. Server configuration is not reevaluated; no accounts or ownership are changed. Preserve both files when copying finalized artifacts to another full CommandBox image.
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
docker run -p 8080:8080 -v "$(pwd):/srv/app" ortussolutions/commandbox:boxlang
```

### Lucee Application with Custom Admin Password

```bash
docker run -p 8080:8080 \
  -e "cfconfig_adminPassword=mySecretPassword" \
  -v "$(pwd):/srv/app" \
  ortussolutions/commandbox:lucee6
```

### Adobe ColdFusion with SSL

```bash
docker run -p 8080:8080 -p 8443:8443 \
  -e "BOX_SERVER_WEB_REWRITES_ENABLE=true" \
  -v "$(pwd):/srv/app" \
  ortussolutions/commandbox:adobe2025
```

### Development with Auto-reload

```bash
docker run -p 8080:8080 \
  -e "BOX_SERVER_PROFILE=development" \
  -v "$(pwd):/srv/app" \
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
      - .:/srv/app
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
      - .:/srv/app
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
    "cfengine": "boxlang@1.6.0"
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
APP_DIR=/srv/app
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

- Select a native UID while retaining shared group access: `--user "$(id -u):1000"`
- Prepare host and reused-volume permissions for the selected UID or GID `1000`; startup does not repair ownership
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
  -v "$(pwd):/srv/app" \
  ortussolutions/commandbox:lucee6
```

#### CommandBox Settings

```bash
# Enable performance optimizations
docker run -p 8080:8080 \
  -e "BOX_SERVER_PROFILE=production" \
  -e "BOX_SERVER_RUNWAR_ARGS=--enable-http2 --nio-enable" \
  -v "$(pwd):/srv/app" \
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
# The image already defaults to commandbox (1000:1000); optionally override its UID
docker run -p 8080:8080 \
  --user 1002:1000 \
  -v "$(pwd):/srv/app" \
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
  -v "$(pwd):/srv/app" \
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
  --tmpfs /opt/lib/serverHome/logs \
  -v "$(pwd):/srv/app" \
  ortussolutions/commandbox:alpine
```

#### Resource Limits

```bash
# Set resource limits
docker run -p 8080:8080 \
  --memory=2g \
  --cpus=2 \
  --pids-limit=100 \
  -v "$(pwd):/srv/app" \
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
        runAsGroup: 1000
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

With `readOnlyRootFilesystem: true`, provide writable volumes for the application, `HOME`, CommandBox and BoxLang homes, server home, and `/tmp`. `STARTUP_DIR` is within the CommandBox home unless overridden. Initialize these volumes with the required application/runtime files and group access before startup.

## Best Practices and Customization

### Customizing Images

To create your own customized Docker image, extend any of the base images and add your own functionality or modules using the examples below. For example, to install the [Ortus Redis extension for Lucee](https://www.ortussolutions.com/products/redis-lucee):

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

Derived images inherit the non-root user. Use an explicit root section only for privileged installation, then restore the runtime identity:

```dockerfile
FROM ortussolutions/commandbox:lucee6
USER root
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
USER commandbox:runwar
```

Use `COPY --chown=commandbox:runwar` for writable application files. After copying, `RUN bash "$BUILD_DIR/util/prepare-runtime.sh"` restores shared-group write access and setgid directories for native UID overrides. Engine warmup also normalizes its generated files without needing root.

### Optimizing Startup Times

Because, with the exception of the CommandBox default engine of Lucee 5, the CFML server engines are downloaded and installed at container runtime. This can result in significant startup time increases (even with Lucee 5 already downloaded in the base image, there is a time penalty for a "cold start"). It is recommended that builds for production use employ an engine-specific variation for the build, which ensures the server is downloaded, in place, and warmed up on container start.

For a basic example, the following will suffice:

```dockerfile
FROM ortussolutions/commandbox:lucee6

# Copy application files to root
COPY --chown=commandbox:runwar ./ ${APP_DIR}/
RUN bash "$BUILD_DIR/util/prepare-runtime.sh"
```

In many cases, you will have tier-specific builds, with custom configuration options. The following employs a `build` directory, which includes additional configuration files for tier-based deployments:

```dockerfile
FROM ortussolutions/commandbox:lucee6

ARG CI_ENVIRONMENT_NAME

# Copy application files to root
COPY --chown=commandbox:runwar ./ ${APP_DIR}/

# Copy tier-only files over
COPY --chown=commandbox:runwar ./build/env/${CI_ENVIRONMENT_NAME}/tier/ ${APP_DIR}/
RUN bash "$BUILD_DIR/util/prepare-runtime.sh"

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

The following complete progressive-build example defaults to `ortussolutions/commandbox:boxlang`. Its final stage copies the application, server home, BoxLang home, and finalized startup files only. Copying `/opt/boxlang` includes the Runwar JARs under `/opt/boxlang/modules/bx-cli/src/libExt`; no build helpers or separate JAR staging are needed. The final stage creates `commandbox:runwar` independently, sets ownership and shared-group permissions, and restores the HTTP healthcheck. The builder's account and `USER` instruction do not transfer between stages.

```dockerfile
ARG BASE_IMAGE_ARG=ortussolutions/commandbox:boxlang
FROM ${BASE_IMAGE_ARG} AS workbench

# Generate the startup script only
ENV FINALIZE_STARTUP=true
RUN "$BUILD_DIR/run.sh"

FROM eclipse-temurin:21-jre-noble AS app

# COPY our generated files
COPY --from=workbench --chown=1000:1000 /srv/app /srv/app
COPY --from=workbench --chown=1000:1000 /opt/lib/serverHome /opt/lib/serverHome
COPY --from=workbench --chown=1000:1000 /opt/boxlang /opt/boxlang
COPY --from=workbench --chown=1000:1000 /opt/commandbox/run/startup-final.sh /opt/commandbox/run/startup-final.sh
COPY --from=workbench --chown=1000:1000 /opt/commandbox/run/startup-final.env /opt/commandbox/run/startup-final.env

ENV APP_DIR=/srv/app
ENV HOME=/home/commandbox
ENV LIB_DIR=/opt/lib
ENV COMMANDBOX_HOME=/opt/commandbox
ENV BOXLANG_HOME=/opt/boxlang
ENV BOXLANG_INSTALL_HOME=/opt/boxlang
ENV STARTUP_DIR=/opt/commandbox/run
RUN groupmod -n runwar ubuntu && \
  usermod -l commandbox -d "$HOME" -g runwar -s /bin/bash ubuntu && \
  mkdir -p "$HOME" && \
  chown -R commandbox:runwar "$HOME" "$APP_DIR" "$LIB_DIR/serverHome" "$BOXLANG_HOME" "$COMMANDBOX_HOME" && \
  chmod -R ug+rwX,o-w "$HOME" "$APP_DIR" "$LIB_DIR/serverHome" "$BOXLANG_HOME" "$COMMANDBOX_HOME" && \
  find "$HOME" "$APP_DIR" "$LIB_DIR/serverHome" "$BOXLANG_HOME" "$COMMANDBOX_HOME" -type d -exec chmod g+s {} +
WORKDIR $APP_DIR

ENV HEALTHCHECK_URI=http://127.0.0.1:8080/
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail "$HEALTHCHECK_URI" || exit 1

USER commandbox:runwar
CMD ["/bin/bash", "-c", "umask 0002; . \"$STARTUP_DIR/startup-final.env\"; exec \"$STARTUP_DIR/startup-final.sh\""]
```

To include your own application, add `COPY --chown=commandbox:runwar ./ /srv/app/` in the workbench stage before generating the startup script.

Build and run the image from a directory containing this `Dockerfile`:

```bash
docker build --file Dockerfile --tag my-commandbox-app .
docker run --rm -p 8080:8080 my-commandbox-app
```

The application is available at `http://localhost:8080/`. The finalized Java process inherits `umask 0002`, allowing newly created runtime files to remain writable by the shared `runwar` group.

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
