# Welcome to the CBJavaloader Project

The CB JavaLoader module will interface with Mark Mandel's JavaLoader to allow you to do a network class loader, compiler and proxy.  

## License
Apache License, Version 2.0.

## Important Links
- https://github.com/ColdBox/cbox-javaloder
- http://forgebox.io/view/javaloader
- Docs: https://github.com/Ortus-Solutions/JavaLoader/wiki

## System Requirements
- Lucee 4.5+
- ColdFusion 9+

## Instructions

Just drop into your **modules** folder or use the box-cli to install

`box install cbjavaloader`

The module has a default folder called `lib` where any jars you drop there will be class loaded automatically.  However, we recommed using the `loadpaths` setting for selecting an array of locations to class load, so when the module updates you won't loose those files.

## Models
The module registers the following mapping in WireBox: `loader@cbjavaloader`. Which is the class you will use to class load, append paths and much more.  Check out the included API Docs for much more information.  The main methods of importance of the java loader are:

* `create( class )` - Create a loaded Java class
* `appendPath( dirPath, filter)` - Appends a directory path of *.jar's,*.classes to the current loaded class loader.
* `getLoadedURLs()` - Get all the loaded URLs

## WireBox DSL
The module also registers a new WireBox DSL called `javaloader`.  You can then use this custom DSL for injecting direct java class loaded classes very easily:

```js
property name="name"  inject="javaloader:{class-path}";
property name="hello" inject="javaloader:HelloWorld";
property name="buffer" inject="javaloader:org.class.path.StringBuffer";
```

## Settings

Here are the module settings you can place in your `ColdBox.cfc` under an `javaloader` structure:

```js
// JavaLoader settings
javaloader = {
	// A single path, and array of paths or a single Jar
	loadPaths = [],
	// Load ColdFusion classes with loader
	loadColdFusionClassPath = false,
	// Attach a custom class loader as a parent
	parentClassLoader = "",
	// Directories that contain Java source code that are to be dynamically compiled
	sourceDirectories = [],
	// the directory to build the .jar file for dynamic compilation in, defaults to ./tmp
	compileDirectory = getDirectoryFromPath( getCurrentTemplatePath() ) & "model/javaloader/tmp",
	// Whether or not the source is trusted, i.e. it is going to change? Defaults to false, so changes will be recompiled and loaded
	trustedSource = false
};
```

Below is a simple example:

```js
/**
* My Event Handler Hint
*/
component{
	// Inject JavaLoader
	property name="javaloader" inject="loader@cbjavaloader";

	// Index
	any function index( event,rc, prc ){
		// creat a java class
		prc.hello = javaloader.create( "HelloWorld" ).init().hello();
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
		// on application start, load up more jars
		javaloader.appendPaths( getSetting( "ApplicationPath" ) & "jars" );
	}

}
```

---

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