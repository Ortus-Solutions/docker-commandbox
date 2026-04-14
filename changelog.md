# CHANGELOG

The versioning notation below denotes the following:  `[CommandBox Version]/[Image release version]`

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----
## [6.3.1/3.15.1]

### Added
- Added additional introspection for multi-site configuration in `server.json` file
- Added `SKIP_PORT_ASSIGNMENTS` environment variable that, when `true`, will rely on the port settings defined in the `server.json` file.

## [6.3.1/3.15.0]

### Changed
- CommandBox version changed to `6.3.1`
- Adobe Coldfusion 2025 to `2025.0.06+331564`
- Adobe Coldfusion 2023 to `2023.0.18+330879`

## [6.2.1/3.14.1] - 2025-12-17

### Changed

- Updated version of `commandbox-boxlang` module

## [6.2.1/3.14.0] - 2025-12-10

### Changed

- RedHat UBI images bumped to ubi-10
- `-ubi9` tags no changed to `-rhel` for clarity on OS.  Old `-ubi9` tags will no longer will be created
- BoxLang images bumped to `v1.8.0`
- Lucee 6 images bumped to `v6.2.3+35`
- Lucee 7 images added (`v7.0.0+395`)
- Adobe Coldfusion 2025 bumped to `2025.0.05+331552`
- Adobe Coldfusion 2023 bumped to `2023.0.17+330864`
- Adobe Coldfusion 2021 bumped to `2021.0.23+330486` - now only building Ubuntu version
- Adobe 2021 Support to be removed in next version due to 11/25/2025 EOL/EOS notice


## [6.2.1/3.13.7] - 2025-11-15

### Changed

- Add pre-dependendency install upgrades of packages to ensure latest security patches are applied
- Adobe Coldfusion 2025 images bumped to `2025.0.04+331512`
- Adobe Coldfusion 2023 images bumped to `2023.0.16+330828`
- Adobe Coldfusion 2021 images bumped to `2021.0.20+330407`
- Boxlang images bump to `v1.7.0`
- JDK/JRE 11 images bumped to version `11.0.29_7`
- JDK/JRE 17 images bumped to version `17.0.17_10`
- JDK/JRE 21 images bumped to version `21.0.9_10`
- JDK/JRE 24 images bumped to version `24.0.2_12`

## [6.2.1/3.13.6] - 2025-08-06

### Changed

- JDK/JRE 11 images bumped to version `11.0.28_6`
- JDK/JRE 17 images bumped to version `17.0.16_8`
- JDK/JRE 21 images bumped to version `21.0.8_9`
- JDK/JRE 24 images bumped to version `24.0.2_12`

## [6.2.1/3.13.5] - 2025-07-03

### Added

- Updated CommandBox to v6.2.1
- EditorConfig support for VSCode and IntelliJ
- Added gitattributes file to ignore unnecessary files in git
- Added markdownlint configuration and markdown lint fix
- Dependabot for automatic dependency updates and security fixes

## [6.2.0/3.13.4] - 2025-05-26

### Changed

- Adobe Coldfusion 2021 updated to `2021.0.20+330407`
- Adobe Coldfusion 2023 updated to `2023.0.14+330784`
- Adobe Coldfusion 2025 updated to `2025.0.02+331451`
- Lucee 6 updated to `6.2.1+122`

## [6.2.0/3.13.3] - 2025-04-29

### Changed

- Boxlang version to 1.0.0

## [6.2.0/3.13.1] - 2025-04-25

### Changed

- JDK/JRE 11 images bumped to version `11.0.27_6`
- JDK/JRE 17 images bumped to version `17.0.15_6`
- JDK/JRE 21 images bumped to version `21.0.7_6`
- JDK/JRE 23 images bumped to version `23.0.2_7`
- JDK/JRE 24 images bumped to version `24.0.1_9`


## [6.2.0/3.13.0] - 2025-04-10

### Changed

- Adobe Coldfusion 2025 updated to `2025.0.01+331420`
- Ubuntu base version changed to v24 ( Noble )

### Added

- Added `:jdk23` and `:jdk24` Build tags

## [6.2.0/3.12.0] - 2025-04-01

### Changed

- CommandBox Binary to v6.2.0


### Added

- Add Adobe Coldfusion 2025 Engine ( version `2025.0.0+331385` )

### Removed

- Removed Adobe Coldfusion 2018 Builds, as it is EOL


## [6.1.0/3.11.0] - 2025-03-05

### Added

- Jarkarta support for [BoxLang](https://boxlang.io/) and Adobe 2025
- Boxlang version bumped to `1.0.0-rc.2`

## [6.1.0/3.10.2] - 2025-02-07

### Changed

- JDK/JRE 11 images bumped to version `11.0.26_4`
- JDK/JRE 17 images bumped to version `17.0.14_7`
- JDK/JRE 21 images bumped to version `21.0.6_7`

## [6.1.0/3.10.1] - 2024-12-25

### Changed

- Adobe 2023 image bump to release version `2023.0.12+330713`
- Adobe 2021 image bump to release version `2021.0.18+330341`

## [6.1.0/3.10.0] - 2024-11-05

### Changed

- CommandBox Binary to v6.1.0
- Lucee Tagged images to v5.4.6+9

## [6.0.0/3.9.10] - 2024-09-10

### Changed

- Adobe 2023 image bump to release version `2023.0.10+330680`
- Adobe 2021 image bump to release version `2021.0.16+330307`

## [6.0.0/3.9.9] - 2024-09-09

### Changed

- Adobe 2023 image bump to release version `2023.0.09+330677`
- Adobe 2021 image bump to release version `2021.0.15+330303`

## [6.0.0/3.9.8] - 2024-07-26

### Changed

- BoxLang Images to Beta 7

## [6.0.0/3.9.7] - 2024-07-24

### Changed

- BoxLang Images to Beta 6

## [6.0.0/3.9.6] - 2024-07-05

### Changed

- BoxLang Images to Beta 4

## [6.0.0/3.9.5] - 2024-06-26

### Added

- Add JDK21 builds for Alpine, UBI, and Ubuntu
- ARM arch builds for Alpine JDK21 Images
- Add BoxLang images

## [6.0.0/3.9.4] - 2024-05-03

### Changed

- Adobe 2023 image bumped to release version `2023.0.08+330668`
- Adobe 2021 image bumped to release version `2021.0.14+330296`

## [6.0.0/3.9.3] - 2024-05-03

### Changed

- JDK/JRE 11 images bumped to version `11.0.23_9`
- JDK/JRE 17 images bumped to version `17.0.11_9`

## [6.0.0/3.9.2] - 2024-03-28

### Changed

- `:lucee5` tags changed to match CommandBox 6 Lucee version of `5.4.4+38`
- Ortus ORM Extension version in `:lucee5` images updated to `v6.5.2`

### Added

- `:lucee5-light` image added

### Fixed

- Changed JVM log util format to use `JAVA_TOOL_OPTIONS` env variable to prevent overwrite of custom `BOX_SERVER_JVM_ARGS` in environment and `server.json` files

## [6.0.0/3.9.1] - 2024-03-28

### Changed

- Adobe 2023 image bumped to release version `2023.0.07+330663`
- Adobe 2021 image bumped to release version `2021.0.13+330286`


## [6.0.0/3.9.0] - 2024-02-16

### Changed

- CommandBox Binary updated to v6.0.0

### Removed

- removed Runwar args as they are no longer suppored
- Changed log pattern to server config default
- Removed code turning off the directory watcher as it is no longer on by default

## [5.9.1/3.8.5] - 2024-01-24

### Changed

- JDK/JRE 11 images bumped to version `11.0.22_7`
- JDK/JRE 17 images bumped to version `17.0.10_7`

## [5.9.1/3.8.4] - 2023-11-14

### Changed

- Adobe 2023 image bumped to release version `2023.0.06+330617`
- Adobe 2021 image bumped to release version `2021.0.12+330257`

## [5.9.1/3.8.3] - 2023-10-11

### Changed

- Adobe 2023 image bumped to release version `2023.0.05+330608`
- Adobe 2021 image bumped to release version `2021.0.11+330247`

## [5.9.1/3.8.2] - 2023-10-02

- Lucee 5 Ortus ORM extension updated to 6.3.2

## [5.9.1/3.8.1] - 2023-09-29

### Changed

- Lucee 5 Ortus ORM extension updated to 6.3.1

## [5.9.1/3.8.0] - 2023-08-17

### Changed

- CommandBox Binary Updated to `v5.9.1`
- Lucee image versions updated to `v5.4.3+2`
- Adobe 2023 image bumped to release version `2023.0.04+330500`
- Adobe 2021 image bumped to release version `2021.0.10+330161`
- Current version of `commandbox-cfconfig` will now fail to start the server if the assigned configfile is not found

### Added

- [Ortus Lucee ORM Extension](https://www.ortussolutions.com/products/orm-extension) now bundled with Lucee images, since Lucee 5.4+ no longer includes an ORM extension

## [5.9.0/3.7.12] - 2023-08-15

### Changed

- Lucee image versions bumped to `v5.3.12+1`

## [5.9.0/3.7.11] - 2023-07-27

### Changed

- JRE 11 versions to `11.0.20_8`
- JRE 17 versions to `17.0.8_7`

## [5.9.0/3.7.10] - 2023-07-12

### Changed

- Adobe 2023 image bumped to release version `2023.0.3+330486`
- Adobe 2021 image bumped to release version `2021.0.9+330148`
- Adobe 2018 image bumped to release version `2018.0.19+330149`

## [5.9.0/3.7.9] - 2023-07-12

### Changed

- Adobe 2023 image bumped to release version `2023.0.2+330482`
- Adobe 2021 image bumped to release version `2021.0.8+330144`
- Adobe 2018 image bumped to release version `2018.0.18+330145`

## [5.9.0/3.7.8] - 2023-07-12

### Added

- Add Java tool options for serialization for all Adobe containers, [per technotes](https://helpx.adobe.com/security/products/coldfusion/apsb23-40.html)

## [5.9.0/3.7.7] - 2023-07-12

### Changed

- Adobe 2023 image bumped to release version `2023.0.1+330480`
- Adobe 2021 image bumped to release version `2021.0.7+330142`
- Adobe 2018 image bumped to release version `2018.0.17+330143`

## [5.9.0/3.7.6] - 2023-05-23

### Changed

- Adobe 2023 image bumped to release version `2023.0.0+330468`

## [5.9.0/3.7.5] - 2023-05-23

### Fixed

- Fixes an issue with manifests no longer being generated by BuildX

## [5.9.0/3.7.4] - 2023-05-03

### Changed

- Removed arm/v7 ( 32 bit ) support due to JDK17 requirements
- CommandBox binary updated to `5.9.0`

## [5.8.0/3.7.3] - 2023-03-23

### Fixed

- Fixes an issue where CLI ID files were not being deleted after installing commandbox and warming up the server

## [5.8.0/3.7.2] - 2023-03-17

### Fixed

- Fixes an issue where specifying an alternate webroot ( e.g. `BOX_SERVER_WEB_WEBROOT` ) fail to start the container

## [5.8.0/3.7.1] - 2023-03-15

### Changed

- Updates `:adobe2021` tag to version `2021.0.06+330132`
- Updates `:adobe2018` tag to version `2018.0.16+330130`

## [5.8.0/3.7.0] - 2023-03-10

## Changed

- CommandBox version to 5.8.0
- Lucee image versions bumped to `v5.3.10+120`
- Ubuntu base version changed to v22 ( Jammy )
- Container stdout log format changed to JSON layout, to ease ingest of container logs from cloud providers
- Changed the default Runwar Log4J pattern layout to include timestamps `[%p] %d{yyyy-MM-dd\'T\'HH:mm:ssXXX} %c - %m%n`.  Example message: `[INFO] 2023-03-09T22:39:37Z runwar.server - Server is up`
- Added support, in container log output, for [JSON log formatting](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/console-log-layout#customize-layout)

## [5.7.0/3.6.4] - 2022-12-15

### Changed

- Lucee image versions bumped to `v5.3.10+97`

## [5.7.0/3.6.3] - 2022-12-07

### Added

- Added [RHEL ubi9](https://catalog.redhat.com/software/containers/redhat/ubi/615bcf606feffc5384e8452e) Builds with tags: `ubi9`, `jre-11-rhel`, `jdk-11-rhel`, `lucee5-rhel`, `adobe2018-rhel`, and `adobe2021-rhel`

### Changed

- CommandBox version to 5.7.0
- Removed the pruning of certain CommandBox modules to allow for more use cases

### Removed

- Removed Adobe Coldfusion 2016 builds

## [5.6.1/3.6.2] - 2022-10-31

### Changed

- `:lucee5` image bumped to use v5.3.9+160
- Resolves [Issue #63](https://github.com/Ortus-Solutions/docker-commandbox/issues/63) - Changed all Adobe images over to use JDK as base instead of JRE due to webservices compilation errors. Size increased by 141MB. [Adobe Bug Report](https://tracker.adobe.com/#/view/CF-4215554)

## [5.6.1/3.6.1] - 2022-10-18

### Fixed

- Resolves [Issue #70](https://github.com/Ortus-Solutions/docker-commandbox/issues/70) - `CFPM_INSTALL` environment variables were not being applied/evaluated correctly

### Added

- Resolves [Issue #64](https://github.com/Ortus-Solutions/docker-commandbox/issues/64) Added support for specifying a user identifier ( `USER_ID` ) at runtime and default UID to `1001` to ease ownership/permissions of mounts.

### Changed

- Updates `:adobe2021` tag to version `2021.0.05+330109`
- Updates `:adobe2018` tag to version `2018.0.15+330106`


## [5.6.1/3.6.0] - 2022-09-05

### Changed

- Updates CommandBox Binary to v5.6.1

## [5.5.2/3.5.4] - 2022-07-29

### Changed

- Update JRE base images to 11.0.16


## [5.5.2/3.5.3] - 2022-05-03

### Added

- Added default `BOX_SERVER_RUNWAR_ARGS` environment variable to disable the Undertow system file watcher.  On large applications, or applications with many static assets, this can speed up start times by 20-30s

## [5.5.2/3.5.2] - 2022-05-03

### Changed

- CommandBox binary updated to `5.5.2`

## [5.5.1/3.5.1] - 2022-05-03

### Changed

- Updates `:adobe2021` tag to version `2021.0.04+330004`
- Updates `:adobe2018` tag to version `2018.0.14+330003`

## [5.5.1/3.5.0] - 2022-05-03

### Changed

- Change base images to use the [`eclipse-temurin` base images](https://hub.docker.com/_/eclipse-temurin)
- Change Ubuntu version to 20.0.0 (focal)
- JREs updated to `jre-11.0.15`
- CommandBox binary updated to `5.5.1`

### Added

- Added `linux/arm/v7` to supported architectures for Debian-based images

## [5.4.2/3.4.5] - 2022-03-12

### Changed

- Moved CFPM commands to after server has been fully seeded
- JREs updated to `jre-11.0.14`

## [5.4.2/3.4.4] - 2021-10-05

### Changed

- Updates CommandBox binary to v5.4.2


## [5.4.1/3.4.3] - 2021-09-15

### Changed

- Updates CommandBox binary to v5.4.1

## [5.4.0/3.4.2] - 2021-09-15

### Changed

- Bumped `:adobe2021` version to `2021.0.2+328618`
- Bumped `:adobe2018` version to `2018.0.12+328566`
- Updates CommandBox binary to v5.4.0

## [5.3.1/3.4.1] - 2021-06-04

### Changed

- Bumped `:lucee5` server version to `5.3.8+189`
- New builds of Adobe images contain latest `mysql-connector-jar`

### Fixed

- Fixed an issue where the `verbose` flag was not being applied to server starts

## [5.3.1/3.4.0] - 2021-06-04

### Changed

- Updates CommandBox binary to v5.3.1
- Marked support for the following environment variables as deprecated, in favor of native CommandBox environment variables. Support for these variables will end in v4.0.0 of the image
-- `SERVER_HOME_DIRECTORY` ( `BOX_SERVER_APP_SERVERHOMEDIRECTORY` )
-- `cfconfigfile` ( `BOX_SERVER_CFCONFIGFILE` )
-- `CFENGINE` ( `BOX_SERVER_APP_CFENGINE` )
-- `HEADLESS` ( `BOX_SERVER_PROFILE` or `ENVIRONMENT` )
-- `SERVER_PROFILE` ( `BOX_SERVER_PROFILE` )
-- `URL_REWRITES` ( `BOX_SERVER_WEB_REWRITES_ENABLE` )
-- `DEBUG` ( `BOX_SERVER_DEBUG` )
- Eliminated random password generation on server startup, if a convention mechanism for changing was not detected.  Since the server profile defaults to `production`, which disables the admin interface, this is no longer necessary

### Fixed

- Documentation updates and corrections

## [5.2.1/3.3.0] - 2021-03-24

### Changed

- JDK11 is now the default Java version for the primary tag `ortussolutions/commandbox:latest`. ( Only the `:adobe2016` engine/tag is currently built with JDK8 )
- JDK8-based default images are now tagged as `:jdk8`
- Removed builds for the following tags and variations as the engines will no longer be updated: `:adobe11`, `lucee45`, `lucee5.2.9`. Older versions of those tags will continue to be available for those who use them, as long as there is demand.
- `HEADLESS` environment flag now assigns a [CommandBox secure profile](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/server-profiles) of `production`, rather than using a custom rewrite file.

### Added

- Added multi-architecture builds to support both x86_64 and ARM architectures
- Disable TLSv1 by default on JRE11 images
- (Issue #56) Added `CFPM_INSTALL` and `CFPM_UNINSTALL` environment variables for Adobe 2021 engines
- Added support for `SERVER_PROFILE` environment variable to utilize [CommandBox secure profiles](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/server-profiles)
- `ENVIRONMENT` variable now auto-assigns server profile, when set to `production` or `development`

### Fixed

- (Issue #60) Fixed an issue where the convention route `.cfconfig.json` was not being parsed to determine if an engine admin password had been set


## [5.2.1/3.2.2] - 2021-03-23

### Changed

- `:adobe2016` images to version `2016.0.17+325979`
- `:adobe2018` images to version `2018.0.11+326016`
- `:adobe2021` images to version `2021.0.1+325996`
- `:lucee5` images to version `5.3.7+48`


## [5.2.1/3.2.1] - 2021-01-22

### Added

- Ensures verbose output is always on when starting the server

### Fixed

- Resolves issue #55 - Fixes a pathing problem with the generated startup script when `$APP_DIR` is not the default and single server mode is on
- Fixes for several typos in comments and scripts

## [5.2.1/3.2.0] - 2020-12-18

### Changed

- Updates CommandBox binary to v5.2.1

### Added

- Enables [single-server mode](https://commandbox.ortusbooks.com/embedded-server/single-server-mode), by default, on all images  (_Note: When single server mode is enabled, the `cfconfig set` commands with a `to` argument - e.g `cfconfig set adminPassword=foo to=cfconfig.json` will only write to files if they are already in existence_)

## [5.2.0/3.1.1] - 2020-11-16

### Changed

- Updates CommandBox binary to v5.2.0
- `:adobe2018` to `v2018.0.10+320417`
- `:adobe2016` to `v2016.0.16+320445`
- `:lucee5` to `v5.3.7+47`

## [5.1.0/3.1.0] - 2020-07-14

### Changed

- Updates CommandBox binary to v5.1.0

## 5.0.1/3.0.2 - 2020-03-26

### Fixed

- Fixes a regression from 3.0.1 caused by an incorrect conditional on checking for the presence of a rewrite configuration file

## [5.0.1/3.0.1] - 2020-03-21

### Fixed

- Fixes a regression where custom rewrite files were being ignored unless `HEADLESS` was present in the environment

## [5.0.1/3.0.0] - 2020-03-18

### Added

- (OC-4) Add handling for a `$FINALIZE_STARTUP` environment variable which will generate the final startup script to a trusted location. Once generated, this script will be authoritative for future container restarts and additional evaluation will be bypassed
- (OC-5) Sets default CommandBox rewrite rules to deny "hidden" files ( e.g. `.env` ) and common config files ( `server.json` )
- (OC-6) Refactor `$HEADLESS` implementation in to startup routine
- (OC-10|Issue #44) Adds supports for _FILE convention variables

## [5.0.0/2.8.1] - 2020-03-11

### Added

- Add additional custom builds for Lucee 5.2.9 and Lucee Light
- (OC-5) Sets default CommandBox rewrite rules to deny "hidden" files ( e.g. `.env` ) and common config files ( `server.json` )


## [5.0.0/2.8.0] - 2020-03-08

### Changed

- Updates CommandBox binary to 5.0.0

### Added

- Changes startup mechanism to use CommandBox generated bash script ( removes need for `box` process wrapper )

## [4.8.0/2.7.3] - 2019-09-26

### Fixed

- Fixes an issue where log output would stop because of rotation

## [4.8.0/2.7.2] - 2019-09-05

### Changed

- Updates CommandBox binary to 4.8.0
- Updates all ACF engines to latest hotfix

## [4.7.0/2.7.1] - 2019-03-07

### Changed

- Updates Commandbox binary to 4.7.0

## [4.6.0/2.7.0] - 2019-03-05

### Added

- Implements the ability to specify a non-root user to run server ( via `USER` environment variable )
- Updates all ACF engines to latest hotfix
- Omits forgebox from module cleanup
- Additional error handling and utilities for manual install
- Adds `fontconfig` for Debian and Alpine to fix PDF generation errors on AdoptOpenJDK base

## [4.6.0/2.6.1] - 2019-03-02

### Changed

- Updates all ACF engines to latest hotfix
- Updates CommandBox binary to v4.6.0

## [4.5.0/2.6.0] - 2019-03-01

### Added

- Adds a `javaVersion` environment variable which can be used to customize the startup JRE of the server

### Changed

- Updates all java versions to use AdoptOpenJDK builds
- Changes the JRE used for Adobe Coldfusion 2018 images to JRE11

## [4.5.0/2.5.0] - 2019-02-23

### Changed

- Updates CommandBox binary to v4.5.0

## [4.4.0/2.4.0] - 2018-11-18

### Changed

- Updates CommandBox binary to v4.4.0

### Added

- Adds the `commandbox-dotenv` module in to all base images

## [4.2.0/2.3.0] - 2018-08-18

### Changed

- Remove no longer needed engine detection from run scripts

### Added

- Optimization and reductions to Debian-based image sizes
- Adds additional APK binaries to Alpine images to support PDF/CFDocument rendering

## [4.2.0/2.2.6] - 2018-08-5

### Changed

- Updates CommandBox binary to v4.2.0

## [4.1.0/2.2.5] - 2018-06-27

### Changed

- Updates CommandBox binary to v4.1.0

## [4.0.0/2.2.4] - 2018-06-16

### Changed

- Revises Travis build structure to better support concurrent image builds

### Added

- Adds warmed-up engine builds for Alpine images
- Additional optimizations to reduce image size

## [4.0.0/2.2.3] - 2018-06-15

### Changed

- Temporarily removes support for `HEAP_SIZE` environment variable due to parse failures with env variables in `server.json`

## [4.0.0/2.2.2] - 2018-06-13

### Changed

- Changes alpine image to use `openjdk:8-alpine`
- Changes image tag in Dockerfile for base Debian image to match official tags on Docker Hub

## [4.0.0/2.2.1] - 2018-06-12

### Added

- Adds ability to specify `HEAP_SIZE` environment variable

### Fixed

- Fixes an issue with `cfconfig_` prefixed environment variables failing

## [4.0.0/2.2.0] - 2018-06-04

### Changed

- Ubuntu base version to use OpenJDK Slim
- Updates to CommandBox v4.0.0
- Changes default CommandBox server engine to Lucee 5

## [3.9.2/2.1.4] - 2018-01-23

### Changed

- Updates to Commandbox v3.9.2
- Changes Docker secrets placeholder for bash compatibility

## [3.9.1/2.1.3] - 2017-11-28

### Fixed

- Fixes a regression where `SSL_PORT` environment variables were being ignored


## [3.9.0/2.1.2] - 2017-11-17

### Changed

- Updates to CommandBox v3.9.0

### Fixed

- Fixes server setting argument name

## [3.8.0/2.1.1] - 2017-11-02

### Changed

- Updates CMD to not persist container runtime settings to server.json

## [3.8.0/2.1.0] - 2017-10-31

### Added

- Adds support for Docker secrets
- Adds casing aliases for environment variables

### Changed

- Updates to CommandBox v3.8+
- Updates runtime output to avoid confusion
- Changes image for alpine build to prevent CommandBox errors when installing dependencies

## [3.7.0/2.0.3] - 2017-06-30

### Changed

- Updates to CommandBox v3.7+
- Delegates cfconfig environment variables to Commandbox v3.7
