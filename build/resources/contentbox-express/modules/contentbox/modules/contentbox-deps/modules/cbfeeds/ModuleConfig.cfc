/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component {

	// Module Properties
	this.title 				= "cbfeeds";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A module that can consume and generate fancy RSS/ATOM feeds";
	this.version			= "@version.number@+9";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbfeeds";
	// CF Mapping
	this.cfMapping			= "cbfeeds";

	function configure(){
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// load parent settings
		parseParentSettings();
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var feeds 			= oConfig.getPropertyMixin( "feeds", "variables", structnew() );

		//defaults
		configStruct.feeds = {
			// leverage the cache for storage of feed reading, leverages the 'default' cache
			useCache  = true,
			// where to store the cache, options are: [ram, file]
			cacheType = "ram",
			// The cache provider
			cacheProvider = "default",
			// if using file cache, the location to store the cached files
			cacheLocation = "",
			// the cache timeout for the items in seconds
			cacheTimeout = 30,
			// the http timeout for the cfhttp operations in seconds
			httpTimeout = 30
		};

		// incorporate settings
		structAppend( configStruct.feeds, feeds, true );
	}
}