/**
* Hashes and passwords and checks password hashes using BCrypt.jar
*/
component singleton threadsafe{
	
	// DI
	property name="javaLoader" 		inject="loader@cbjavaloader";
	property name="settings"	 	inject="coldbox:setting:bcrypt";
	
	/**
	* Constructor
	*/
	public BCrypt function init(){
		return this;
	}
	
	/**
	* On DI Complete load library
	*/
	public function onDIComplete(){
		loadBCrypt();
	}
	
	/**
	* Hash a password
	* @password The plain string password
	* @workFactor Optional work factor
	*/
	public string function hashPassword( required string password, workFactor=variables.settings.workFactor ){
		var salt = variables.BCrypt.genSalt( javaCast( "int", arguments.workFactor ) );
		return variables.BCrypt.hashpw( password, salt );
	}
	
	/**
	* Check a password
	* @candidate incoming password
	* @bCryptHash The bCrypt hash to compare
	*/
	public boolean function checkPassword( required string candidate, required string bCryptHash ){
		return variables.BCrypt.checkpw( candidate, bCryptHash );
	}
	
	/**
	* Load the library
	*/
	private void function loadBCrypt(){
		tryToLoadBCryptFromClassPath();
		
		if( NOT isBCryptLoaded() ){
			tryToLoadBCryptWithJavaLoader();
		}
		
		if( NOT isBCryptLoaded() ){
			throw( "BCrypt not successfully loaded.  BCrypt.jar must be present in the ColdFusion classpath or at the setting javaloader_libpath.  No operations are available." );
		}
	}

	/**
	* Try to load if java lib in CF Path
	*/
	private void function tryToLoadBCryptFromClassPath(){
		try{
			variables.bcrypt = createObject( "java", "BCrypt" );
		} catch( any error ) {
		}
	}

	/**
	* Load via module
	*/
	private void function tryToLoadBCryptWithJavaLoader(){
		try{
			variables.bcrypt = javaLoader.create( "BCrypt" );
		} catch( any error ) {
		}
	}

	/**
	* Is BCrypt loaded
	*/
	private boolean function isBCryptLoaded(){
		return structKeyExists( variables, "BCrypt" );
	}
}