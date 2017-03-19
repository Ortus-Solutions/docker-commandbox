/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component{

	// Module Properties
	this.title 				= "validation";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "This module provides server-side validation to ColdBox applications";
	this.version			= "1.2.1+29";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbvalidation";
	// Model Namespace
	this.modelNamespace		= "cbvalidation";
	// CF Mapping
	this.cfmapping			= "cbvalidation";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies That Must Be Loaded First, use internal names or aliases
	this.dependencies		= [ "cbi18n" ];
	// ColdBox Static path to validation manager
	this.COLDBOX_VALIDATION_MANAGER = "cbvalidation.models.ValidationManager";

	/**
	* Configure module
	*/
	function configure(){
		// Mixin our own methods on handlers, interceptors and views via the ColdBox UDF Library File setting
		arrayAppend( controller.getSetting( "ApplicationHelper" ), "#moduleMapping#/models/Mixins.cfm" );
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var configSettings = controller.getConfigSettings();
		// parse parent settings
		parseParentSettings();
		// Did you change the validation manager?
		if( configSettings.validation.manager != this.COLDBOX_VALIDATION_MANAGER ){
			binder.map( alias="validationManager@cbvalidation", force=true )
				.to( configSettings.validation.manager )
				.asSingleton();
		}
		// setup shared constraints
		wirebox.getInstance( "validationManager@cbvalidation" )
			.setSharedConstraints( configSettings.validation.sharedConstraints );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var appHelperArray = controller.getSetting( "ApplicationHelper" );
		var mixinToRemove = "#moduleMapping#/models/Mixins.cfm";
		var mixinIndex = arrayFindNoCase( appHelperArray, mixinToRemove );
		
		// If the mixin is in the array
		if( mixinIndex ) {
			// Remove it
			arrayDeleteAt( appHelperArray, mixinIndex );
			// Arrays passed by value in Adobe CF
			controller.setSetting( "ApplicationHelper", appHelperArray );
		}
	}

	/**
	* Prepare settings and returns true if using i18n else false.
	*/
	private function parseParentSettings(){
		/**
		Sample:
		validation = {
			manager = "class path" // if overriding
			sharedConstraints = {
				name = {
					field = { constraints here }
				}
			}

		}
		*/
		// Read parent application config
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var validationDSL	= oConfig.getPropertyMixin( "validation", "variables", structnew() );
		var configStruct 	= controller.getConfigSettings();

		// Default Config Structure
		configStruct.validation = {
			manager = this.COLDBOX_VALIDATION_MANAGER,
			sharedConstraints = {}
		};

		// manager
		if( structKeyExists( validationDSL, "manager" ) ){
			configStruct.validation.manager = validationDSL.manager;
		}
		// shared constraints
		if( structKeyExists( validationDSL, "sharedConstraints" ) ){
			structAppend( configStruct.validation.sharedConstraints, validationDSL.sharedConstraints, true );
		}
	}

}
