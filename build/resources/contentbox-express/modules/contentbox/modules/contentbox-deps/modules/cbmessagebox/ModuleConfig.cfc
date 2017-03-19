component {

	// Module Properties
	this.title 				= "ColdBox MessageBox";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A nice module to produce informative messageboxes leveraging Flash RAM";
	this.version			= "2.2.0+10";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbmessagebox";
	// CF Mapping
	this.cfMapping			= "cbmessagebox";

	function configure(){
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// parse parent settings
		parseParentSettings();
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
		var messagebox		= oConfig.getPropertyMixin( "messagebox", "variables", structnew() );

		//defaults
		configStruct.messagebox = {
			template 		= "/cbmessagebox/views/MessageBox.cfm",
			styleOverride 	= false,
			moduleRoot		= moduleMapping
		};

		// Incorporate settings
		structAppend( configStruct.messagebox, messagebox, true );
	}

}
