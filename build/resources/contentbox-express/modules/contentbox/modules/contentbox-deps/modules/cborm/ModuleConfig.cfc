/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component {

	// Module Properties
	this.title 				= "cborm";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "ColdBox ORM enhancements for Hibernate";
	this.version			= "1.3.0+47";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cborm";
	// Model Namespace
	this.modelNamespace		= "cborm";
	// CF Mapping
	this.cfmapping			= "cborm";
	// Dependencies
	this.dependencies 		= [ "cbvalidation" ];

	/**
	* Configure Module
	*/
	function configure(){

		// Register Custom DSL, don't map it because it is too late, mapping DSLs are only good by the parent app
		controller.getWireBox().registerDSL( namespace="entityService", path="#moduleMapping#.models.dsl.ORMDSL" );

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = [
				// CriteriaBuilder Events
				"onCriteriaBuilderAddition", "beforeCriteriaBuilderList", "afterCriteriaBuilderList", "beforeCriteriaBuilderCount",
				"afterCriteriaBuilderCount",
				// ORM Bridge Events
				"ORMPostNew", "ORMPreLoad", "ORMPostLoad", "ORMPostDelete", "ORMPreDelete", "ORMPreUpdate", "ORMPostUpdate",
				"ORMPreInsert", "ORMPostInsert", "ORMPreSave", "ORMPostSave", "ORMPostFlush", "ORMPreFlush"
			]
		};

		// Custom Declared Interceptors
		interceptors = [
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Read parent application config
		var oConfig = controller.getSetting( "ColdBoxConfig" );
		// Default Config Structure
		controller.setSetting( "orm", {
			injection = {
				enabled = true, include = "", exclude = ""
			}
		});
		// Check if we have defined DSL first in application config
		var ormDSL = oConfig.getPropertyMixin( "orm", "variables", structnew() );
		// injection
		if( structCount( ormDSL ) ){
			structAppend( controller.getSetting( "orm" ).injection, ormDSL.injection, true);
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}