/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
********************************************************************************
*/
component {

	// Module Properties
	this.title 				= "cbi18n";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "Gives i18n and localization capabilities to applications";
	this.version			= "1.3.1+56";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbi18n";
	// Model Namespace
	this.modelNamespace		= "cbi18n";
	// Auto Map Models Directory
	this.autoMapModels		= true;
	// CF Mapping
	this.cfmapping			= "cbi18n";

	/**
	* Configure Module
	*/
	function configure(){
		// Mixin our own methods on handlers, interceptors and views via the ColdBox UDF Library File setting
		arrayAppend( controller.getSetting( "ApplicationHelper" ), "#moduleMapping#/models/Mixins.cfm" );
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		parseParentSettings();

		if( len( controller.getSetting( "customResourceService" ) ) ){
			binder.map( "resourceService@cbi18n", true ).to( controller.getSetting( "customResourceService" ) );
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var appHelperArray 	= controller.getSetting( "ApplicationHelper" );
		var mixinToRemove 	= "#moduleMapping#/models/Mixins.cfm";
		var mixinIndex 		= arrayFindNoCase( appHelperArray, mixinToRemove );
		
		// If the mixin is in the array
		if( mixinIndex ) {
			// Remove it
			arrayDeleteAt( appHelperArray, mixinIndex );
			// Arrays passed by value in Adobe CF
			controller.setSetting( "ApplicationHelper", appHelperArray );
		}
	}

	/**
	* Listen when modules are activated to load their i18n capabilities
	*/
	function afterConfigurationLoad( event, interceptData ){
		var modules 			= controller.getSetting( "modules" );
		var moduleService 		= controller.getModuleService();
		var moduleConfigCache 	= moduleService.getModuleConfigCache();

		for( var thisModule in modules ){
			// get module config object
			var oConfig = moduleConfigCache[ thisModule ];
			// Get i18n Settings
			var i18nSettings = oConfig.getPropertyMixin( "i18n", "variables", structnew() );

			// Verify it exists and use it, else ignore.
			if( structCount( i18nSettings ) ){
				var flagi18n = false;
				// setup the default settings
				modules[ thisModule ].i18n = {
					defaultResourceBundle = "",
					defaultLocale = "",
					localeStorage = "",
					unknownTranslation = "",
					logUnknownTranslation = false,
					resourceBundles = {},
					customResourceService = ""
				};
				// Append incoming structure
				structAppend( modules[ thisModule ].i18n, i18nSettings, true );


				// process i18n settings
				if( len( modules[ thisModule ].i18n.defaultResourceBundle ) AND NOT len( controller.getSetting( "defaultResourceBundle" ) ) ){
					controller.setSetting( "defaultResourceBundle", modules[ thisModule ].i18n.defaultResourceBundle );
					flagi18n = true;
				}
				if( len( modules[ thisModule ].i18n.unknownTranslation ) AND NOT len( controller.getSetting( "unknownTranslation" ) ) ){
					controller.setSetting( "unknownTranslation", modules[ thisModule ].i18n.unknownTranslation );
					flagi18n = true;
				}
				if( len( modules[ thisModule ].i18n.defaultLocale ) AND NOT len( controller.getSetting( "defaultLocale" ) ) ){
					controller.setSetting( "defaultLocale", modules[ thisModule ].i18n.defaultLocale );
					flagi18n = true;
				}
				if( len( modules[ thisModule ].i18n.localeStorage ) AND NOT len( controller.getSetting( "localeStorage" ) ) ){
					controller.setSetting( "localeStorage", modules[ thisModule ].i18n.localeStorage );
					flagi18n = true;
				}

				if( structCount( modules[ thisModule ].i18n.resourceBundles ) ){
					structAppend( controller.getSetting( "resourceBundles" ), modules[ thisModule ].i18n.resourceBundles, true );
					flagi18n = true;
				}
				
				if( flagi18n ){
					controller.setSetting( "using_i18N", true );
				}
			}
		}

		// startup the i18n engine if using it, else ignore.
		if( controller.getSetting( "using_i18n" ) ){
			wirebox.getInstance( "i18n@cbi18n" ).configure();
		}
	}

	/**
	* Prepare settings and returns true if using i18n else false.
	*/
	private function parseParentSettings(){
		// Read parent application config
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var i18n 			= oConfig.getPropertyMixin( "i18N", "variables", structnew() );
		var configStruct 	= controller.getConfigSettings();

		// Defaults
		configStruct[ "defaultResourceBundle" ] 	= "";
		configStruct[ "defaultLocale" ] 			= "";
		configStruct[ "localeStorage" ] 			= "";
		configStruct[ "unknownTranslation" ] 		= "";
		configStruct[ "logUnknownTranslation" ] 	= false;
		configStruct[ "using_i18N" ] 				= false;
		configStruct[ "resourceBundles" ]			= structNew();
		configStruct[ "RBundles" ]					= structNew();
		configStruct[ "customResourceService" ]		= "";

		// Check if empty
		if ( NOT structIsEmpty( i18n ) ){

			// Check for DefaultResourceBundle
			if ( structKeyExists( i18n, "DefaultResourceBundle" ) AND len( i18n.defaultResourceBundle ) ){
				configStruct[ "DefaultResourceBundle" ] = i18n.defaultResourceBundle;
			}

			// Check for DefaultLocale
			if ( structKeyExists( i18n, "DefaultLocale" ) AND len( i18n.DefaultLocale ) ){
				if( find( "_", i18n.defaultLocale) ){
					configStruct[ "DefaultLocale" ] = lcase( listFirst( i18n.defaultLocale, "_" ) ) & "_" & ucase( listLast( i18n.defaultLocale, "_" ) );
				}
				else{
					configStruct[ "DefaultLocale" ] = i18n.defaultLocale;
				}
			}

			// Check for LocaleStorage
			if ( structKeyExists( i18n, "localeStorage" ) AND len( i18n.localeStorage ) ){
				configStruct[ "localeStorage" ] = i18n.localeStorage;
				if( NOT reFindNoCase( "^(session|cookie|client|request)$",configStruct[ "localeStorage" ]) ){
					throw(message="Invalid local storage scope: #configStruct[ "localeStorage" ]#",
			   			  detail="Valid scopes are session,client, cookie, or request",
			   			  type="InvalidLocaleStorage" );
				}
			}

			// Check for UnknownTranslation
			if ( structKeyExists( i18n, "unknownTranslation" ) AND len( i18n.unknownTranslation ) ){
				configStruct[ "unknownTranslation" ] = i18n.unknownTranslation;
			}

			// Check for UnknownTranslation
			if ( structKeyExists( i18n, "logUnknownTranslation" ) AND i18n.logUnknownTranslation ){
				configStruct[ "logUnknownTranslation" ] = i18n.logUnknownTranslation;
			}

			// Check for ResourceBundles
			if ( structKeyExists( i18n, "resourceBundles" ) AND isStruct( i18n.resourceBundles ) ){
				configStruct[ "resourceBundles" ] = i18n.resourceBundles;
			}

			//Check for custom ResourceService
			if( structKeyExists( i18n, "customResourceService" ) AND len( i18n.customResourceService ) ){
				configStruct[ "customResourceService" ] = i18n.customResourceService;	
			}

			// set i18n being used
			configStruct[ "using_i18N" ] = true;
		}

		return configStruct[ "using_i18N" ];
	}
}
