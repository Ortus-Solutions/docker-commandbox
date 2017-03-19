component {

	// Module Properties
	this.title 				= "CryptBox";
	this.author 			= "Seth Feldkamp";
	this.webURL 			= "https://github.com/sfeldkamp/coldbox-plugin-BCrypt";
	this.description 		= "A ColdBox library for BCrypt for creating cryptographically strong (and slow) password hashes.";
	this.version			= "2.1.0";
	this.modelNamespace		= "bcrypt";
	this.cfmapping			= "bcrypt";
	// Module Dependencies That Must Be Loaded First, use internal names or aliases
	this.dependencies		= [ "cbjavaloader" ];

	function configure(){
		// Module Settings		
  		settings = {
  			libPath = modulePath & "/models/lib"
  		};
	}
  		
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// parse parent settings
		parseParentSettings();
		// Class load antisamy
		wireBox.getInstance( "loader@cbjavaloader" )
			.appendPaths( settings.libPath );
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var bcryptDSL 		= oConfig.getPropertyMixin( "bCrypt", "variables", structnew() );

		//defaults
		configStruct.bCrypt = {
			workFactor = 12
		};

		// incorporate settings
		structAppend( configStruct.bCrypt, bcryptDSL, true );
	}

}