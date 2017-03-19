/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Loads External Java Classes, while providing access to ColdFusion classes by interfacing with JavaLoader
* it Stores a reference in server scope to avoid leakage.
*/
component accessors="true" singleton{

	/**
	* Module Settings
	*/
	property name="moduleSettings" inject="coldbox:moduleSettings:cbjavaloader";

	/**
	* ID key saved in server scope to avoid leakage
	*/
	property name="staticIDKey";

	/**
	* Constructor
	* @coldbox.inject coldbox
	*/
	function init( required coldbox ){
		// setup a static ID key according to coldbox app
		variables.staticIDKey = "cbox-javaloader-#arguments.coldbox.getAppHash()#";
		// setup wirebox reference
		variables.wirebox 	  = arguments.coldbox.getWireBox();
		return this;
	}

	/**
	* Setup class loading
	* @loadPaths.hint An array of directories to classload
	* @loadColdFusionClassPath.hint Loads the CF library class loader as well
	* @parentClassLoader.hint The parent java.lang.ClassLoader to attach the network class loader to.
	*/
	function setup(){
		// verify we have it loaded
		if( not isJavaLoaderInScope() ){
			lock name="#variables.staticIDKey#" throwontimeout="true" timeout="30" type="exclusive"{
				if( not isJavaLoaderInScope() ){
					setJavaLoaderInScope( variables.wirebox.getInstance( "jl@cbjavaloader" ) );
				}
			}
		} else {
			// reconfigure it, maybe settings changed
			lock name="#variables.staticIDKey#" throwontimeout="true" timeout="30" type="exclusive"{
				getJavaLoaderFromScope().init( argumentCollection=variables.moduleSettings );
			}
		}
	}

    /**
    * Get the original java loader object from scope
    */
    function getJavaLoader(){
    	return getJavaLoaderFromScope();
    }

	/**
	* Retrieves a reference to the java class. To create a instance, you must run init() on this object
	*/
	function create( required string className ){
		return getJavaLoaderFromScope().create( argumentCollection=arguments );
	}

	/**
	* Appends a directory path of *.jar's,*.classes to the current loaded class loader.
	* @dirPath.hint The directory absolute path to load
	* @filter.hint The directory filter
	*/
	function appendPaths( required string dirPath, string filter="*.jar" ){
		// Convert paths to array of file locations
		var qFiles	  		= arrayOfJars( argumentCollection=arguments );
		var iterator 		= qFiles.iterator();
		var thisFile 		= "";
		var URLClassLoader  = "";

		// Try to check if javaloader in scope? else, set it up.
		if( NOT isJavaLoaderInScope() ){
			setup( qFiles );
			return;
		}

		// Get URL Class Loader
		URLClassLoader = getURLClassLoader();

		// Try to load new locations
		while( iterator.hasNext() ){
			thisFile = createObject( "java", "java.io.File" ).init( iterator.next() );
			if(NOT thisFile.exists()){
				throw( message="The path you have specified could not be found",
					   detail=thisFile.getAbsolutePath() & "does not exist",
					   type="PathNotFoundException" );
			}
			// Load up the URL
			URLClassLoader.addUrl( thisFile.toURL() );
		}
	}

	/**
	* Get all the loaded URLs
	*/
	array function getLoadedURLs(){
		var loadedURLs 	= getURLClassLoader().getURLs();
		var returnArray = arrayNew(1);
		var x			= 1;

		for(x=1; x lte ArrayLen(loadedURLs); x=x+1){
			arrayAppend(returnArray, loadedURLs[x].toString());
		}

		return returnArray;
	}

	/**
	* Returns the java.net.URLClassLoader in case you need access to it
	*/
	any function getURLClassLoader(){
		return getJavaLoaderFromScope().getURLClassLoader();
	}

	/**
	* Get the Javaloader Version
	*/
	string function getVersion(){
		return getJavaLoaderFromScope().getVersion();
	}

	/**
	* Get an array of jars from a directory location
	*/
	array function arrayOfJars( required string dirPath, string filter="*.jar" ){
		if( not directoryExists( arguments.dirPath ) ){
			throw( message="Invalid library path", detail="The path is #path#", type="JavaLoader.DirectoryNotFoundException" );
		}

		return directoryList( arguments.dirPath, true, "array", arguments.filter, "name desc" );
	}

	/************************************** private *********************************************/

	private function setJavaLoaderInScope( required any javaLoader ){
		server[ getStaticIDKey() ] = arguments.javaLoader;
	}

	private function getJavaLoaderFromScope(){
		return server[ getstaticIDKey() ];
	}


	private boolean function isJavaLoaderInScope(){
		return structKeyExists( server, getstaticIDKey());
	}

}