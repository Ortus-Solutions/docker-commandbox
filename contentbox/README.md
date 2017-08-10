Tags
======

* `:latest`, `:3.7.0` - Latest stable version
* `:snapshot` - Development/BE version of this image (Not of ContentBox)

> Look in the tags section for other specific ContentBox versions

Description 
================

ContentBox is a professional open source (Apache 2 License) modular content management engine that allows you to easily build websites, blogs, wikis, complex web applications and even power mobile or cloud applications. Built with a secure and flexible modular core, designed to scale, and combined with world-class support, ContentBox can be deployed to any Java server or ColdFusion (CFML) server.

Learn more about ContentBox at https://www.ortussolutions.com/products/contentbox



Usage
================

This section assumes you are using the [Official Docker Image](https://hub.docker.com/r/ortussolutions/contentbox/)


To deploy a new application, first pull the image:

```bash
docker pull ortussolutions/contentbox
```

The image is packaged with a self-contained **express** version, which uses an in-memory [H2 database engine](http://www.h2database.com/html/main.html).  To stand up an image for testing purposes, using an unconfigured express edition, simply run:

```bash
docker run -p 8080:8080 \
	-e express=true \
	-e install=true \
	ortussolutions/contentbox
```


A new container will be spun up from the image and, upon opening your browser to `http://[docker machine ip]:8080`, you will be directed to configure your [ContentBox](https://www.ortussolutions.com/products/contentbox) installation wizard.

This image is self-contained, which means it will be destroyed when the container is stopped.  To persist your data and shared files, you will need to provide a mount point to store your information.

The directory `/app`, within the container, is mapped as the application web root.  Custom configurations, modules and directories can be mounted within the web root to customize your [ContentBox](https://www.ortussolutions.com/products/contentbox)/[Coldbox](https://www.ortussolutions.com/products/coldbox) installation.

By convention, the `express` H2 database is stored at `/data/contentbox/db` inside the container.  In addition, the default storage location for the CMS user media assets is set to `/app/includes/shared/media`.   Let's mount both of those points, so that our database and user-uploaded assets persists between restarts:


```
docker run -p 8080:8080 \
	-e express=true \
	-e install=true \
	-v `pwd`/contentbox-db:/data/contentbox/db \
	-v `pwd`/contentbox-media:/app/includes/shared/media \
	ortussolutions/contentbox
```


Now once you've started up your image, you can walk through the initial configuration and then simply stop the container and then start it without the environment variable `install` specified.   Your database and uploads will be persisted and the installer will be removed automatically on container start.

See environment variables below for advanced database and shared asset configuration options.

Environment Variables
=====================

ContentBox allows you to pass a number of environment variables in to the image to allow for configuration of installation.

For advanced configurations to external DBMS systems, all of the supported JDBC drivers in your CMFL engine can be configured by specifying the environment variables to connect.  Alternately, you may specify a `CFCONFIG` environment variable which points to file containing your engine configuration, including datasources.  For more information on runtime configuration using `CFCONFIG`, see the [Forgebox Instructions](https://www.forgebox.io/view/commandbox-cfconfig)  By convention, the datasource expected for the image should be named `contentbox`.

To programatically configure the database on container start, environment variables which represent your datasource configuration should be provided.  There are two patterns supported:

1.  `DB_DRIVER` configuration - which may be used for Adobe Coldfusion servers
2.  `DB_CLASS` configuration - which configures a datasource by JDBC driver and connection string.

An example container `run` command, configuring a MySQL database would be executed like so:


```
docker run -p 8080:8080 \
	-e 'express=true' \
	-e 'installer=true' \
	-e 'cfconfig_adminPassword=myS3cur3P455' \
	-e "DB_CONNECTION_STRING=jdbc:mysql://mysqlhost:3306/contentbox_docker?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true" \
	-e 'DB_CLASS=org.gjt.mm.mysql.Driver' \
	-e 'DB_USER=contentbox_user' \
	-e 'DB_PASSWORD=myS3cur3P455' \
	-v `pwd`/contentbox-media:/app/includes/shared/media \
	ortussolutions/contentbox
```


To use the `DB_DRIVER` syntax for Adobe Coldfusion, an example `run` command would be:


```
docker run -p 8080:8080 \
	-e 'CFENGINE=adobe@11' \
	-e 'installer=true' \
	-e 'cfconfig_adminPassword=myS3cur3P455' \
	-e 'DB_DRIVER=MSSQLServer' \
	-e 'DB_HOST=sqlserver_host' \
	-e 'DB_PORT=1433' \
	-e 'DB_NAME=contentbox_docker' \
	-e 'DB_USER=sa' \
	-e 'DB_PASSWORD=myS3cur3P455' \
	-v `pwd`/contentbox-media:/app/includes/shared/media \
	ortussolutions/contentbox
```

You can see that these commands can become quite long.  As such, using Docker Compose or [CFConfig](https://www.gitbook.com/book/ortus/cfconfig-documentation/details) may provide a more workable alternative for your deployment environment.

Available environment variables, specific to the ContentBox image, include:

* `express=true` - Uses an H2, in-memory database.  Useful for very small sites or for testing the image. See http://www.h2database.com/html/main.html
* `install=true` (alias: `installer`) - Adds the installer module at runtime, to assit in configuring your installation.  You would omit this from your `run` command, once your database has been configured
* `BE=true` - Uses the bleeding edge snapshot of the ContentBox CMS, else we will defer to the latest stable version of ContentBox.
* `FWREINIT_PW` - Allows you to specify the reinit password for the ColdBox framework
* `SESSION_STORAGE` - Allows the customization of session storage.  Allows any valid `this.sessionStorage` value, available in [Application.cfc](http://docs.lucee.org/reference/tags/application.html).  By default it will use the JDBC connection to store your sessions in your database of choice.
* `DISTRIBUTED_CACHE` - Allows you to specify a CacheBox cache region for distributing ContentBox content, flash messages, cache storage, RSS feeds, sitemaps and settings.  There are only three cache regions defined in this image: `default`, `template` and `jdbc`.  `jdbc` is the default cache that will distribute your data, `default` and `template` are in-memory caches.  Please see the distributed caching section below to see how to register more caches.
* `H2_DIR` - Allows you to specify a custom directory path for your H2 database.  By convention, this is set to `/data/contentbox/db` within the container
* `contentbox_default_*` - All [Contentbox](https://www.ortussolutions.com/products/contentbox) "[Geek Settings](https://contentbox.ortusbooks.com/content/using/system/settings.html)" may be provided as environment variables, prefixed with `contentbox_default_`, allowing granular control of your ContentBox settings.  
* `ORM_SECONDARY_CACHE` - If `true` it will activate the ORM secondary cash to the `ehcache` provider.  By default it is turned off.
* `ORM_DIALECT` - You can choose the specific ORM dialect if needed, if not we will try to auto-detect it for you.

In addition, the CommandBox docker image environment variables are also available to use in your container.  For CommandBox image environment variable options, please read [the description text in `ortussolutions/commandbox`](https://hub.docker.com/r/ortussolutions/commandbox/). For additional information on using the CommandBox docker image, see [the initial release blog entry](https://www.ortussolutions.com/blog/commandbox-docker-image-360-released). 


Distributed Cache
================

By default, this image is configured to use the connected database as a caching storage as well.  This will allow you to distribute your stack with pseudo-caching enabled.  

However, if you would like to have a real distributed cache like Redis or Couchbase connected to your images, you will need to use the appropriate CacheBox providers and your own custom `CacheBox.cfc` configuration file.  For an example of using Redis, check out our compose repository: [https://github.com/Ortus-Solutions/docker-contentbox-distributed](https://github.com/Ortus-Solutions/docker-contentbox-distributed).

Issues
================

Please submit issues to our repository: [https://github.com/Ortus-Solutions/docker-commandbox/issues](https://github.com/Ortus-Solutions/docker-commandbox/issues)

Building Locally + Contributing
===============================

You can use the following to build the image locally:

```
docker build --no-cache -f ./Dockerfile ./
```

You can test the image built correctly:

```
docker run -t -p 8080:8080 -e 'express=true' -e 'install=true' [hash]
```

Once the hash is returned, you can use the following for publishing to the Ortus repos (If you have access)

```
docker tag [hash] ortussolutions/contentbox:3.7.0
docker tag ortussolutions/contentbox:3.7.0 ortussolutions/contentbox:latest
docker tag ortussolutions/contentbox:3.7.0 ortussolutions/contentbox:snapshot
docker push ortussolutions/contentbox
```

