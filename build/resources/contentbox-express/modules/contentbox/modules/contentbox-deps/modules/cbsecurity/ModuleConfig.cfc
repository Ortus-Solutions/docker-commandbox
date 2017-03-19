/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* ---
* Module Configuration
*/
component {

	// Module Properties
	this.title 				= "cbsecurity";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "This module provides a security rule engine for ColdBox Apps";
	this.version			= "1.3.0+00003";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbsecurity";
	// Model Namespace
	this.modelNamespace		= "cbsecurity";
	// CF Mapping
	this.cfmapping			= "cbsecurity";

	/**
	* Module Config
	*/
	function configure(){}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var configSettings = controller.getConfigSettings();
		// Parse parent settings
		parseParentSettings();
		// Verify we have settings, else ignore loading automatically
		if( structKeyExists( configSettings, "cbsecurity" ) && structCount( configSettings.cbsecurity ) ){
			controller.getInterceptorService()
				.registerInterceptor( 
					interceptorClass		= "cbsecurity.interceptors.Security",
					interceptorProperties	= configSettings.cbsecurity,
					interceptorName			= "CBSecurity"
				);
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	/**
	* Prepare settings and returns true if using i18n else false.
	*/
	private function parseParentSettings(){
		var oConfig 			= controller.getSetting( "ColdBoxConfig" );
		var configStruct 		= controller.getConfigSettings();
		var securitySettings	= oConfig.getPropertyMixin( "cbsecurity", "variables", structnew() );

		// default
		configStruct.cbSecurity = {};

		// Incorporate settings
		structAppend( configStruct.cbsecurity, securitySettings, true );
	}

}