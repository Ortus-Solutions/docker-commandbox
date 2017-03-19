[![Build Status](https://travis-ci.org/coldbox-modules/cbox-i18n.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbox-i18n)

# WELCOME TO THE COLDBOX I18N & LOCALIZATION MODULE
This module will enhance your ColdBox applications with i18n capabilities,
resource bundles and localization.

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- Documentation: https://github.com/ColdBox/cbox-i18n/wiki
- Source: https://github.com/ColdBox/cbox-i18n
- ForgeBox: https://forgebox.io/view/i18n
- [Changelog](changelog.md)

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- Railo 4+ (Deprecated)
- ColdFusion 9+

## INSTRUCTIONS

Just drop into your **modules** folder or use the box-cli to install

`box install cbi18n`

This module registers the following models in WireBox:

- `i18n@cbi18n` : Helper with all kinds of methods for localization
- `resourceService@cbi18n` : Service to interact with language resource bundles - You may override this service by providing a `customResourceService` key in your configuration.  [More information on custom resource services](https://github.com/coldbox-modules/cbox-i18n/wiki/Custom-Resource-Services).

## Settings
You can add a `i18n` structure of settings to your `ColdBox.cfc` or to any other module configuration file: `ModuleConfig.cfc` to configure the module:

```js
i18n = {
    // The base path of the default resource bundle to load
    defaultResourceBundle = "includes/i18n/main",
    // The default locale of the application
    defaultLocale = "en_US",
    // The storage to use for user's locale: session, client, cookie, request
    localeStorage = "cookie",
    // The value to show when a translation is not found
    unknownTranslation = "**NOT FOUND**",
    logUnknownTranslation = true | false,
    // Extra resource bundles to load
    resourceBundles = {
        alias = "path"
    },
    //Specify a Custom Resource Service, which should implement the methods or extend the base i18n ResourceService ( e.g. - using a database to store i18n )
    customResourceService = ""
};
```

Each module in your ColdBox Application can have its own resource bundles that can be loaded by this module.

## Mixin Helpers
The module registers the following methods for **handlers/layouts/views/interceptors**:

```js
/**
* Get the user's currently set locale or default locale according to settings
*/
function getFWLocale()

/**
* Set the locale for a specific user
* @locale The locale to set. Must be Java Style Standard: en_US, if empty it will default to the default locale
* @dontLoadRBFlag Flag to load the resource bundle for the specified locale (If not already loaded)
* 
* @return i18n Service
*/
function setFWLocale( string locale="", boolean dontloadRBFlag=false )

/**
* Retrieve a resource from a resource bundle with replacements or auto-loading
* @resource The resource (key) to retrieve from the main loaded bundle.
* @defaultValue A default value to send back if the resource (key) not found
* @locale Pass in which locale to take the resource from. By default it uses the user's current set locale
* @values An array, struct or simple string of value replacements to use on the resource string
* @bundle The bundle alias to use to get the resource from when using multiple resource bundles. By default the bundle name used is 'default'
*/
function getResource(
    required resource,
    defaultValue,
    locale,
    values,
    bundle,
)

// Alias to getResource
function $r()
```

You can read more about this module here: https://github.com/ColdBox/cbox-i18n/wiki

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
####HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12