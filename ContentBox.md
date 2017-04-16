Tags
======

* `:latest`, `:3.5.1.0` - Latest stable version
* `:snapshot` - Development/BE version

Description 
================

ContentBox is a professional open source (Apache 2 License) modular content management engine that allows you to easily build websites, blogs, wikis, complex web applications and even power mobile or cloud applications. Built with a secure and flexible modular core, designed to scale, and combined with world-class support, ContentBox can be deployed to any JEE server or ColdFusion (CFML) server.

Learn more about ContentBox at https://www.ortussolutions.com/products/contentbox



Usage
================

This section assumes you are using the [Official Docker Image](https://hub.docker.com/r/ortussolutions/contentbox/)

By default, the directory `/app` in the container is mapped as the application web root.  To deploy a new application, first pull the image:

```
docker pull ortussolutions/contentbox
```

The image is packaged with a self-contained "express" version, which uses an in-memory HSQL database.  To stand up an image for testing purposes, using an unconfigured express edition, simply run:

```
docker run -p 8080:8080 -e express=true -e install=true ortussolutions/contentbox
```

A new image will be spun up and, upon opening your browser to `http://[docker machine ip]:8080`, you will be directed to configure your [ContentBox](https://www.ortussolutions.com/products/contentbox) installation.

This image is self-contained, which means it will be destroyed when the container is stopped.  To persist your data and shared files, you will need to provide a mount point to store your information.  By convention, the `express` HSQL database is stored at `/data/contentbox/db` inside the container.  Let's mount that point, so that our database persists between restarts:

```
docker run -p 8080:8080 -e express=true -e install=true -v  `pwd`/contentbox-db:/data/contentbox/db ortussolutions/contentbox
```

Now once you've started up your image, you can walk through the initial configuration and then simply stop the container and then start it without the environment variable `install` specified.   Your database will be persisted and the installer will be removed automatically on container start.

See environment variables below for advanced database and shared asset configuration options.

Environment Variables
=====================

Contentbox allows you to pass a number of environment variables in to the image to allow for configuration of installation.

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
ortussolutions/contentbox
```

To use the `DB_DRIVER` syntas for ACF, an example configuration would look like:

```
docker run -p 8080:8080 \
-e 'CFENGINE=adobe@11'
-e 'installer=true' \
-e 'cfconfig_adminPassword=myS3cur3P455' \
-e 'DB_DRIVER=MSSQLServer' \
-e 'DB_HOST=sqlserver_host' \
-e 'DB_PORT=1433' \
-e 'DB_NAME=contentbox_docker' \
-e 'DB_USER=sa' \
-e 'DB_PASSWORD=myS3cur3P455' \
ortussolutions/contentbox
```

You can see that these commands can become quite long.  As such, using Docker Compose or [CFConfig](https://www.gitbook.com/book/ortus/cfconfig-documentation/details) may provide a more workable alternative for your deployment environment.

Available environment variables, specific to the ContentBox image, include:

* `express=true` - Uses an HSQL, in-memory database.  Useful for very small sites or for testing the image
* `install=true` (alias: `installer`) - Adds the installer module at runtime, to assit in configuring your installation.  You would omit this from your `run` command, once your database has been configured
* `FWREINT_PW` - Allows you to specify the reinit password for the ColdBox framework
* `HSQL_DIR` - Allows you to specify a custom directory path for your HSQL database.  By convention, this is set to `/data/contentbox/db` within the container
* `contentbox_*` - All [Contentbox](https://www.ortussolutions.com/products/contentbox) "[Geek Settings](https://contentbox.ortusbooks.com/content/using/system/settings.html)" may be provided as environment variables, allowing granular control of your ContentBox settings.  


In addition, the CommandBox docker image environment variables are also available to use in your container.  For CommandBox image environment variable options, please read [the description text in `ortussolutions/commandbox`](https://hub.docker.com/r/ortussolutions/commandbox/). For additional information on using the CommandBox docker image, see [the initial release blog entry](https://www.ortussolutions.com/blog/commandbox-docker-image-360-released). 

Issues
================

Please submit issues to our repository: [https://github.com/Ortus-Solutions/docker-commandbox/issues](https://github.com/Ortus-Solutions/docker-commandbox/issues)
