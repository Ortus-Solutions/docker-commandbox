/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
********************************************************************************
*/
component {

	// Module Properties
	this.title 				= "AntiSamy";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "Leverages the AntiSamy libraries for XSS cleanups";
	this.version			= "1.3.0+00033";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbantisamy";
	// CF Mapping
	this.cfmapping			= "cbantisamy";
	// Module Dependencies That Must Be Loaded First, use internal names or aliases
	this.dependencies		= [ "cbjavaloader" ];

	function configure(){
		// Custom Declared Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.AutoClean", name="AutoClean@CBAntiSamy" }
		];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var settings = controller.getConfigSettings();
		// parse parent settings
		parseParentSettings();
		// Class load antisamy
		controller.getWireBox().getInstance( "loader@cbjavaloader" ).appendPaths( settings.antisamy.libPath );
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
		var antisamyDSL 	= oConfig.getPropertyMixin( "antisamy", "variables", structnew() );

		// Setup Default Settings
		var defaults = {
			// The library path
			libPath = modulePath & "/models/lib",
			// Activate auto request capture cleanups
			autoClean = false,
			// Default Policy to use, available are: antisamy, ebay, myspace, slashdot and tinymce
			defaultPolicy = "ebay",
			// Custom Policy absolute path, leave empty if not used
			customPolicy = ""
		};
		if( !structKeyExists( configStruct, "antiSamy" ) ){ configStruct.antiSamy = {}; }
		structAppend( configStruct.antiSamy, defaults );

		// incorporate custom settings
		structAppend( configStruct.antisamy, antisamyDSL, true );

	}

}