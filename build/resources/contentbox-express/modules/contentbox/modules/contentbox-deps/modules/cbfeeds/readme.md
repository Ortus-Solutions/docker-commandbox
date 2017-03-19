[![Build Status](https://travis-ci.org/coldbox-modules/cbox-feeds.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbox-feeds)

#WELCOME TO THE CBFEEDS MODULE

A nice and fancy way to consume and produce RSS, ATOM feeds the ColdBox way!

##DOCUMENTATION
https://github.com/coldbox-modules/cbox-feeds/wiki

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- https://github.com/ColdBox/cbox-feeds
- https://www.forgebox.io/view/cbfeeds

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdFusion 10+

#INSTRUCTIONS

Just drop into your **modules** folder or use the box-cli to install

`box install cbfeeds`

The module registers the following mappings in WireBox:

* `FeedReader@cbfeeds` - Reads feeds with caching enhancements
* `feedGenerator@cbfeeds` - Generate all kinds of feeds

Then you can use each of the model objects to read or generate feeds to your heart's content.

##Settings
The module can be configured via settings in your `ColdBox.cfc` in a structure called `feeds`:

```js
feeds = {
    // leverage the cache for storage of feed reading, leverages the 'default' cache
    useCache  = true,
    // The cache provider to use for storing the cached elements
    cacheProvider = "default",
    // where to store the cache, options are: [ram, file]
    cacheType = "ram",
    // if using file cache, the location to store the cached files
    cacheLocation = "",
    // the cache timeout for the items in seconds
    cacheTimeout = 30,
    // the http timeout for the cfhttp operations in seconds
    httpTimeout = 30
};
```

##Samples + Documentation
If you want examples just look at the shell sample app in the repository:
https://github.com/coldbox-modules/cbox-feeds

Or the online documentation for the module:

* https://github.com/coldbox-modules/cbox-feeds/wiki


********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
ww.ortussolutions.com
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
