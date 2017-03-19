/**
* Module Config
*/
component {

	// Module Properties
	this.title 				= "ColdBox Mail Services";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A module that allows you to leverage many mail service protocols in a nice abstracted API";
	this.version			= "1.2.0+00028";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbmailservices";
	// Model Namespace
	this.modelNamespace		= "cbmailservices";
	// CF Mapping
	this.cfmapping			= "cbmailservices";

	function configure(){

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var configSettings = controller.getConfigSettings();
		// Parse parent settings
		parseParentSettings();
		// Map the mail service with correct arguments
		binder.map( "MailService@cbmailservices" )
			.to( "cbmailservices.models.MailService" )
			.initArg( name="mailSettings", 	value=configSettings.mailSettings )
			.initArg( name="tokenMarker", 	value=configSettings.mailSettings.tokenMarker );

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
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var mailsettings	= oConfig.getPropertyMixin( "mailsettings", "variables", structnew() );

		//defaults
		configStruct.mailsettings = {
			tokenMarker = "@"
		};

		// Incorporate settings
		structAppend( configStruct.mailsettings, mailsettings, true );
	}

}