/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component {

	// Module Properties
	this.title 				= "JavaLoader";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A JavaLoader Module for ColdBox";
	this.version			= "1.1.0+00002";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbjavaloader";
	// CF Mapping
	this.cfmapping			= "cbjavaloader";
	
	function configure(){
		// Register Custom DSL, don't map it because it is too late, mapping DSLs are only good by the parent app
		controller.getWireBox()
			.registerDSL( namespace="javaloader", path="#moduleMapping#.models.JavaLoaderDSL" );
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var settings = controller.getConfigSettings();
		// parse parent settings
		parseParentSettings();
		// Bind Core JavaLoader
		binder.map( "jl@cbjavaloader" )
			.to( "#moduleMapping#.models.javaloader.JavaLoader" )
			.initArg( name="loadPaths", 				value=settings.modules.cbjavaloader.settings.loadPaths )
			.initArg( name="loadColdFusionClassPath", 	value=settings.modules.cbjavaloader.settings.loadColdFusionClassPath )
			.initArg( name="parentClassLoader", 		value=settings.modules.cbjavaloader.settings.parentClassLoader )
			.initArg( name="sourceDirectories", 		value=settings.modules.cbjavaloader.settings.sourceDirectories )
			.initArg( name="compileDirectory", 			value=settings.modules.cbjavaloader.settings.compileDirectory )
			.initArg( name="trustedSource", 			value=settings.modules.cbjavaloader.settings.trustedSource );
		// Load JavaLoader and class loading
		wirebox.getInstance( "loader@cbjavaloader" ).setup();
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	/**
	* Get an array of jar files
	*/
	private array function getJars( required string dirPath, string filter="*.jar" ){
		if( not directoryExists( arguments.dirPath ) ){
			throw( message="Invalid library path", detail="The path is #arguments.dirPath#", type="JavaLoader.DirectoryNotFoundException" );
		}

		return directoryList( arguments.dirPath, true, "array", arguments.filter, "name desc" );
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var javaLoaderDSL 	= oConfig.getPropertyMixin( "javaloader", "variables", structnew() );

		// Default Configurations
		configStruct.modules.cbjavaloader.settings = {
			// The array paths to load
			loadPaths = variables.modulePath & "lib",
			// Load ColdFusion classes with loader
			loadColdFusionClassPath = false,
			// Attach a custom class loader as a parent
			parentClassLoader = "",
			// Directories that contain Java source code that are to be dynamically compiled
			sourceDirectories = [],
			// the directory to build the .jar file for dynamic compilation in, defaults to ./tmp
			compileDirectory = variables.modulePath & "model/javaloader/tmp",
			// Whether or not the source is trusted, i.e. it is going to change? Defaults to false, so changes will be recompiled and loaded
			trustedSource = false
		};

		// Default load paths, empty array
		if( !structKeyExists( javaLoaderDSL, "loadPaths" ) ){
			javaLoaderDSL.loadPaths = [];
		}
		// Array of locations
		if( isArray( javaLoaderDSL.loadPaths ) ){
			var aJarPaths = [];
			for( var thisLocation in javaLoaderDSL.loadPaths ){
				if( !directoryExists( thisLocation ) ){
					throw( "Cannot load #thisLocation# as it is not a valid path" );
				}
				aJarPaths.addAll( getJars( thisLocation ) );
			}	
			javaLoaderDSL.loadPaths = aJarPaths;
		}
		// Single directory? Get all Jars in it
		if( isSimpleValue( javaLoaderDSL.loadPaths ) and directoryExists( javaLoaderDSL.loadPaths ) ){
			javaLoaderDSL.loadPaths = getJars( javaLoaderDSL.loadPaths );
		} 
		// Single Jar?
		if( isSimpleValue( javaLoaderDSL.loadPaths ) and fileExists( javaLoaderDSL.loadPaths ) ){
			javaLoaderDSL.loadPaths = [ javaLoaderDSL.loadPaths ];
		} 
		// If simple value and no length
		if( isSimpleValue( javaLoaderDSL.loadPaths ) and !len( javaLoaderDSL.loadPaths ) ){
			javaLoaderDSL.loadPaths = [];
		} 

		// incorporate settings		
		structAppend( configStruct.modules.cbjavaloader.settings, javaLoaderDSL, true );
	}

}
