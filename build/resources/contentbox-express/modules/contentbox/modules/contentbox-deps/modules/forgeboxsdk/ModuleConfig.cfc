/**
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Module Config
*/
component {

	// Module Properties
	this.title 				= "ForgeBox SDK";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "ForgeBox SDK API";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "forgeboxsdk";
	// Model Namespace
	this.modelNamespace		= "forgeboxsdk";
	// CF Mapping
	this.cfmapping			= "forgeboxsdk";
	// Module Dependencies
	this.dependencies 		= [];

	/**
	* Configure
	*/
	function configure(){
		// SES Routes
		routes = [
			// Convention Route
			{ pattern="/:handler/:action?" }
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

	//**************************************** PRIVATE ************************************************//	

}