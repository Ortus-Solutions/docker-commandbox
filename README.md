Official CommandBox Dockerfiles 
=========================

[![Build Status](https://travis-ci.org/Ortus-Solutions/docker-commandbox.svg)](https://travis-ci.org/Ortus-Solutions/docker-commandbox) [![Docker Image Pulls Badge](https://badgen.net/docker/pulls/ortussolutions/commandbox)](https://hub.docker.com/r/ortussolutions/commandbox/)

This is the repository for official Dockerfiles for Commandbox images



## How it works

The Docker files are used to produce the `ortussolutions/commandbox` [base images on Docker Hub](https://hub.docker.com/r/ortussolutions/commandbox/tags).   Leveraging CommandBox allows you to configure your entire ColdFusion CFML engine environment from a single `server.json` file in the root of your project.

Tags
======

_Note: For references to the specific versions of CommandBox used within image versions, [please see the Changelog](https://github.com/Ortus-Solutions/docker-commandbox/blob/main/changelog.md)._

* `:latest` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Dockerfile)) - Latest stable version 
* `:3.9.2` - Tagged version of the image - not to be confused with the version of CommandBox within the image
* `:snapshot` - Development/BE version
* `:[tag]-snapshot` - Development/BE version of a tagged variations (e.g. - `:adobe2021-snapshot`)
* `:jdk8` - Base image using OpenJDK8
* `:jre11` - Base image using OpenJDK11 JRE
* `:jdk11` - Base image using OpenJDK11 full JDK
* `:jre17` - Base image using OpenJDK17 JRE
* `:jdk17` - Base image using OpenJDK17 full JDK
* `:alpine` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/Alpine.Dockerfile)) - [Alpine Linux](https://alpinelinux.org/about/) version of the image - slight decrease in overall size and optimizations for containerized runtimes
* `:ubi9` ([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/base/ubi9.Dockerfile)) - [RHEL Universal Base Image](https://catalog.redhat.com/software/containers/ubi9/ubi/615bcf606feffc5384e8452e) version of the image
* `:[engine][version]` - Containers with warmed-up engines - saves having to download the server WAR during container start: `:lucee5`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Lucee5.Dockerfile)), `:lucee-light`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/LuceeLight.Dockerfile)), `:lucee5-light`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Lucee5Light.Dockerfile)), `:adobe2018`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2018.Dockerfile)), `:adobe2021`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2021.Dockerfile)), `:adobe2023`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/debian/Adobe2023.Dockerfile))
* `:[engine][version]-alpine` - Alpine linux versions of the image with warmed-up engines:
`:lucee5-alpine`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Lucee5.Dockerfile)), `:lucee-light-alpine`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/LuceeLight.Dockerfile)), `:lucee5-light-alpine`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Lucee5Light.Dockerfile)), `:adobe2018-alpine`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Adobe2018.Dockerfile)), `:adobe2021-alpine`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/alpine/Adobe2021.Dockerfile))
* `:[engine][version]-ubi9` - RHEL ubi9 versions of the image with warmed-up engines:
`:lucee5-ubi9`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Lucee5.Dockerfile)), `:lucee-light-ubi9`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/LuceeLight.Dockerfile)), `:lucee5-light-ubi9`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Lucee5Light.Dockerfile)), `:adobe2018-ubi9`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Adobe2018.Dockerfile)), `:adobe2021-ubi9`([Dockerfile](https://github.com/Ortus-Solutions/docker-commandbox/blob/master/builds/ubi9/Adobe2021.Dockerfile))

_*Note*: The `:latest` tag currently uses OpenJDK11, as do all other pre-built engine images.  If you required JDK 8 or JDK 17 support in your app or engine, use the `:jdk8` or `:jdk17` tags, respectively._ 


Description 
=================

CommandBox allows you to configure your entire CFML engine environment at runtime using file or environment-based conventions.  For more information on how to leverage CommandBox in developing and deploying your applications, see the [official documentation](https://commandbox.ortusbooks.com/). 

In addition the CommandBox modules of [`dotenv`](https://www.forgebox.io/view/commandbox-dotenv) and [`cfconfig`](https://cfconfig.ortusbooks.com/) are included in these pre-built images, which allow you to leverage additional runtime environmental and server configuration options.

Current CFML engines supported are:

- Lucee:  5+
- Adobe ColdFusion 2018+

You may also [specify a custom WAR for deployment](https://commandbox.ortusbooks.com/embedded-server/multi-engine-support#war-support), using the `server.json` configuration.

Usage
================

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

Supported Architectures and Operating Systems
=============================================

All Debian-based images currently support `linux/amd64`, `linux/arm64` and `linux/arm/v7` architecture. Alpine builds are currently only supported on `linux/amd64`

Environment Variables
=====================

The CommandBox Docker image supports the use of environmental variables for the configuration of your servers.  Specifically, the image includes the [`cfconfig` CommandBox module](https://www.forgebox.io/view/commandbox-cfconfig), which allows you to provide custom settings for your engine, including the admin password.

### Port Variables

* `$PORT` - The port which your server should start on.  The default is `8080`.
* `$SSL_PORT` - If applicable, the ssl port used by your server The default is `8443`.

### Load Balancer Configuration

In order to use the [multi-site features](https://commandbox.ortusbooks.com/embedded-server/multi-site-support) of CommandBox v6 and above, if your multi-site setup is domain-aware, you will need to set [the environment variable](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/proxy-ip) `BOX_SERVER_WEB_useProxyForwardedIP=true`.  Note, though, that doing so will open your container up to threat vectors by providing visitors with the ability to circumvent:

* Internal-only host matching
* IP restrictions on admin blocking

as well as potentially allowing the spoofing of client certs and/or SSL redirects/validation. Because of this, if you choose to enable this setting, you should take care to ensure that your containers are _only publicly accessible via the load balancer_ and exposed container ports on the Docker host are not publicly available.  Once this setting is enabled, however, headers such as `X-Forwarded-Host` sent by the upstream load balancer will be honored when service multi-site traffic.


### HTTP/2 Support

As of Commandbox `v5.3.0`, all CommandBox servers have HTTP/2 enabled by default. For browser support of this protocol, you will need to enable SSL and provide a certificate.

### Server Configuration Variables

The following environment variables may be provided to modify your runtime server configuration.  Please note that environment variables are case sensitive and, while some lower/upper case aliases are accounted for, you should use consistent casing in order for these variables to take effect.

* `BOX_SERVER_APP_SERVERHOMEDIRECTORY` - When provided, a custom path to your server home directory will be assigned.  By default, this path is set as `${LIB_DIR}/serverHome`, which resolves to `/usr/local/lib/serverHome` in most builds. The Alpine-based builds will default to `/usr/lib/serverHome`. ( _Note: You may also provide this variable in your app's customized `server.json` file_ )
* `APP_DIR` - Application directory (web root). By default, this is `/app`.  If you are deploying an application with mappings outside of the root, you would want to provide this environment variable to point to the webroot ( e.g. `/app/wwwroot` )
* `USER` - When provided the server process will run under the provided user account name
* `USER_ID` - Numeric. When provided in conjunction with a `USER` environment variable, the UID of the user will be assigned this number.  This can be useful for ensuring permissions of mounted volumes and files
* `cfconfig_[engine setting]` - Any environment variable provided which includes the `cfconfig_` prefix will be determined to be a `cfconfig` setting and the value after the prefix is presumed to be the setting name.  
* `BOX_SERVER_CFCONFIGFILE` - A `cfconfig`-compatible JSON file may be provided with this environment variable.  The file will be loaded and applied to your server.  If an `adminPassword` key exists, it will be applied as the Server and Web context passwords for Lucee engines. You may instead add a `.cfconfig.json` file to the root of the `APP_DIR` and it will be picked up automatically. 
* `BOX_SERVER_APP_CFENGINE` - Using the `server.json` syntax, allows you to specify the CFML engine for your container ( e.g. `lucee@5` ). Defaults to the CommandBox default ( currently `lucee@4.5`) 
* `BOX_SERVER_RUNWAR_CONSOLE_APPENDERLAYOUT` - When setting this to `JSONTemplateLayout`, the log output of the container will be in [`ndjson`](http://ndjson.org/).  For more information on this setting, please see [the CommandBox documentation on customizing log layouts](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/console-log-layout#customize-layout)
* `FINALIZE_STARTUP` - When provided a final startup script will be generated, which will be considered authoritative the next time the container/image starts. The caveat to this, however, is that the finalized startup script will bypass the evaluation checks for all of the other environment variables in this list as those values will be explicitly exported in the startup file.
* `BOX_SERVER_PROFILE` - When set, this will be applied as the runtime [CommandBox server profile](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/server-profiles).  By default, CommandBox will set this value to the `production` mode, since the container server binds to all interfaces on `0.0.0.0`. If you wish a lower level of security, you will need to provide this variable or set it in your `server.json` file.
* `BOX_SERVER_WEB_REWRITES_ENABLE` - A boolean value, specifying whether URL rewrites will be enabled/disabled on the server. Setting this environment variable will overwrite any settings within the app's `server.json` file.
* `CFPM_INSTALL` and `CFPM_UNINSTALL`  - Supported for Adobe Coldfusion 2021 engines. When provided as a delimited list of [Coldfusion Package Manager](https://helpx.adobe.com/coldfusion/using/coldfusion-package-manager.html) packages, these will be installed ( or uninstalled, respectively ), prior to the server start.  A warmed-up server is required to use these variables.
* `BOX_INSTALL`/`box_install` - When set to true, the `box install` command will be run before the server is started to ensure any dependencies configured in your `box.json` file are installed

### Docker Runtime Variables

* `$HEALTHCHECK_URI` - Specifies the URI endpoint for container [health checks](https://docs.docker.com/engine/reference/builder/#healthcheck).  By default, this defaults to `http://127.0.0.1:${PORT}/` at 20 second intervals, a timeout of 30 seconds,  with 15 retries before the container is marked as failed.  _Note: Since the interval, timeout, and retry settings cannot be set dynamically, if you need to adjust these, you will need to build from a Dockerfile which provides a new [`HEALTHCHECK` command](https://docs.docker.com/engine/reference/builder/#healthcheck)

### Deprecated Environment Variables

The following variables are still supported, however they are deprecated and support will be removed in the next major release version of the image:

* `SERVER_HOME_DIRECTORY` - Use `BOX_SERVER_APP_SERVERHOMEDIRECTORY` instead
* `CFCONFIG` and `cfconfigfile` - Use `BOX_SERVER_CFCONFIGFILE` instead
* `CFENGINE` - Use `BOX_SERVER_APP_CFENGINE` instead
* `HEADLESS=true` - Use `BOX_SERVER_PROFILE=production` instead
* `SERVER_PROFILE` - Use `BOX_SERVER_PROFILE` instead
* `URL_REWRITES`/`url_rewrites` - Use `BOX_SERVER_WEB_REWRITES_ENABLE` instead

Docker Secrets
==============

[Docker secrets](https://docs.docker.com/engine/swarm/secrets/) can use two storage mechanisms:

* Secret values stored as files on the host (non-swarm mode).
* `docker secret`-managed key/value pairs (swarm mode).

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


Best Practices and Customization
================================

### Customizing Images

To create your own, customized Docker image, use [our Dockerfile repository](https://github.com/Ortus-Solutions/docker-commandbox/tree/development/builds) as a reference to begin your customizations.  You can extend any of the base images and add your own additional functionality or modules.  For example, to install the [Ortus Couchbase extension for Lucee](https://www.ortussolutions.com/products/couchbase-lucee):

```
FROM ortussolutions/commandbox:lucee5

ARG REDIS_EMAIL
ARG REDIS_LICENSE_KEY
ARG REDIS_ACTIVATION_CODE


# Install the Ortus Redis cache extension from Forgebox
RUN box install 5C558CC6-1E67-4776-96A60F9726D580F1

# Scope in our args for extension activation
REDIS_EXTENSION_EMAIL=$REDIS_EMAIL
REDIS_EXTENSION_LICENSE_KEY=$REDIS_LICENSE_KEY
REDIS_EXTENSION_ACTIVATION_CODE=$REDIS_ACTIVATION_CODE
REDIS_EXTENSION_SERVER_TYPE=Production

# WARM UP THE SERVER WITH THE NEW EXTENSION
RUN ${BUILD_DIR}/util/warmup-server.sh
```

We recommend using the pre-tagged images as your base, rather than starting from scratch.  

### Optimizing Startup Times

Because, with the exception of the CommandBox default engine of Lucee 5, the CFML server engines are downloaded and installed at container runtime. This can result in significant startup time increases ( even with Lucee 5 already downloaded in the base image, there is a time penalty for a "cold start" ). It is recommended that builds for production use employ an engine-specific variation for the build, which ensures the server is downloaded, in place, and warmed up on container start.   

For a basic example, the following will suffice:

```
FROM ortussolutions/commandbox:lucee5

# Copy application files to root
COPY ./ ${APP_DIR}/
```

In many cases, you will have tier-specific builds, with custom configuration options.  The following employs a `build` directory, which includes additional configuration files for tier-based deployments:

```
FROM ortussolutions/commandbox:lucee5

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


#### Multi-Stage Builds

As of v3.0.0 of the image you can create multi-stage builds which include only a shell script to start the server, the RunWar servlet container, and the application/engine. _This build is finalized, however, so the startup script will bypass all environmental and server evaluation in favor of the variables provided in the generated shell script._  This means that you will need to provide all secrets and variables needed by your server and CFConfig files during the initial build phase, as the `.env` and `.cfconfig.json` files will not be in play during the server startup.

A finalized image reduces container startup times by up to 80% and reduces the final image size by up to 50%.  Multi-stage builds are ideal for creating production images.  The environment variable `FINALIZE_STARTUP`, when provided, will only generate the startup script.  The script written is considered authoritative and will be used on the next container start.

To leverage this with a multi-stage build:

```
FROM ortussolutions/commandbox:lucee5 as workbench

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

#### Single-Stage With Script Finalization

You may also create this finalized startup script in a single-stage build:

```
FROM ortussolutions/commandbox:lucee5

# Generate the finalized startup script and exit
RUN export FINALIZE_STARTUP=true;$BUILD_DIR/run.sh;unset FINALIZE_STARTUP
```

This created image will contain the authoritative script with its runtime benefits and caveats ( see above ).  Unlike the multi-stage build above, however , secret expansion will take place prior to image start, with the caveat that _any environment variables in existence when the finalized script was generated will overwrite the runtime-provided variables or secrets_.


About CommandBox
================

*CommandBox* is a standalone, native, [modular](https://www.forgebox.io/type/commandbox-modules) CFML development and deployment tool for Windows, Mac, and Linux which provides a CLI for server orchestration, developer productivity, tool interaction, package management, application scaffolding, and some sweet ASCII art. 
It is open for extensibility for any ColdFusion (CFML) project and is written in CFML, allowing developers to easily write their own [modules](https://www.forgebox.io/type/commandbox-modules).  It tightly integrates with the CFML open source hub [ForgeBox](https://www.forgebox.io/), so developers can share modules world-wide.

[Learn more about CommandBox](https://www.ortussolutions.com/products/commandbox)


Issues
================

Please submit issues to our repository: [https://github.com/Ortus-Solutions/docker-commandbox/issues](https://github.com/Ortus-Solutions/docker-commandbox/issues)

## LICENSE
Apache License, Version 2.0.

<hr/>

#### HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, it's not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

#### THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
fv
