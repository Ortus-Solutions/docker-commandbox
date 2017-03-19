[![Build Status](https://travis-ci.org/coldbox-modules/cbox-cborm.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbox-cborm)

#Welcome To The ColdBox ORM Module

This module provides you with several enhancements when interacting with the
ColdFusion ORM via Hibernate.  It provides you with virtual service layers,
active record patterns, criteria and detached criteria queries, entity compositions, populations and so much more to make your ORM life easier!

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS

**Source & Changelog**
- https://github.com/coldbox-modules/cbox-cborm
- [Changelog](changelog.md)

**Documentation**
- https://github.com/coldbox-modules/cbox-cborm/wiki/Base-ORM-Service
- https://github.com/coldbox-modules/cbox-cborm/wiki/Active-Entity
- https://github.com/coldbox-modules/cbox-cborm/wiki/Virtual-Entity-Service
- https://github.com/coldbox-modules/cbox-cborm/wiki/ColdBox-ORM-Event-Handler
- https://github.com/coldbox-modules/cbox-cborm/wiki/ColdBox-Criteria-Builder
- https://github.com/coldbox-modules/cbox-cborm/wiki/ColdBox-Detached-Criteria-Builder

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdFusion 10+

# INSTRUCTIONS
Just drop into your **modules** folder or use the box-cli to install

`box install cborm`

Unfortunately, due to the way that ORM is loaded by ColdFusion, if you are using the ORM EventHandler or ActiveEntity or any ColdBox Proxies that require ORM, you must create an Application Mapping in the `Application.cfc` like this:

```js
this.mappings[ "/cborm" ] = COLDBOX_APP_ROOT_PATH & "modules/cborm";
```

## WireBox DSL
The module also registers a new WireBox DSL called `entityservice` which can produce virtual or base orm entity services:

- `entityservice` -  Inject a global ORM service
- `entityservice:{entityName}` - Inject a Virtual entity service according to `entityName`

## Settings
Here are the module settings you can place in your `ColdBox.cfc` under an `orm` structure:

```js
orm = {
    injection = {
        enabled = true, include = "", exclude = ""
    }
}
```

## Validation
We have also migrated the `UniqueValidator` from the **validation** module into our
ORM module.  It is mapped into wirebox as `UniqueValidator@cborm` so you can use in your constraints like so:

```js
{ fieldName : { validator: "UniqueValidator@cborm" } }
```


********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
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