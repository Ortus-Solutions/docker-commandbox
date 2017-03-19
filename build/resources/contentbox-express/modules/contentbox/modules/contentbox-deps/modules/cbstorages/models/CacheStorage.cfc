/**
* Copyright Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* This storage leverages cachebox in order to operate. It simulates a session/client storage bucket in cache.
*/
component accessors="true" threadsafe singleton{

	/**
	* The cache provider to use
	*/
	property name="cache";

	/**
	* Application name, comes from the application settings
	*/
	property name="appName";

	/**
	* Session Timeout, defaults to 60 minutes
	*/
	property name="timeout" default="60" type="numeric";

	/**
	* Settings
	*/
	property name="settings";

	/**
	* Constructor
	* @settings The storage settings struct
	* @cachebox A reference to CacheBox
	* @settings.inject coldbox:setting:storages
	* @cachebox.inject cachebox
	*/
	function init( required settings, required cachebox ){
		// Get application name
		variables.appName 	= application.applicationName;
		// Store settings
		variables.settings 	= arguments.settings;
		// Default timeout
		variables.timeout 	= arguments.settings.cacheStorage.timeout;
		// Provider
		variables.cache 	= arguments.cachebox.getCache( variables.settings.cacheStorage.cachename );

		return this;
	}

	/**
	* Set a new variable in storage
	* @name The name of the data key
	* @value The value of the data to store
	*/
	CacheStorage function setVar( required name, required value ){
		var storage = getStorage();
		// store in bucket
		storage[ arguments.name ] = arguments.value;
		// save it back in cache
		cache.set( getSessionKey(), storage, variables.timeout, 0 );

		return this;
	}

	/**
	* Get a new variable in storage if it exists, else return default value, else will return null.
	* @name The name of the data key
	* @defaultValue The default value to return if not found in storage
	*/
	any function getVar( required name, defaultValue ){
		var storage = getStorage();
		// check if exists
		if( structKeyExists( storage, arguments.name ) ){
			return storage[ arguments.name ];
		}
		// default value
		if( structKeyExists( arguments, "defaultValue" ) ){
			return arguments.defaultValue;
		}
	}

	/**
	* Delete a variable in storage
	* @name The name of the data key
	*/
	CacheStorage function deleteVar( required name ){
		var storage = getStorage();
		// verify and delete
		if( structKeyExists( storage, arguments.name ) ){
			structDelete( storage, arguments.name );
			// store it back
			cache.set( getSessionKey(), storage, variables.timeout, 0 );
		}
		return this;
	}

	/**
	* Checks wether the permanent variable exists
	* @name The name of the data key
	*/
	boolean function exists( required name ){
		// check if exists
		return structKeyExists( getStorage(), arguments.name );
	}

	/**
	* Clear the entire coldbox session storage
	*/
	CacheStorage function clearAll(){
		cache.set( getSessionKey(), {}, variables.timeout, 0 );
		return this;
	}

	/**
	* Get the entire storage scope from cache. If it does not exist, then create the default bucket
	*/
	struct function getStorage(){
		var cacheKey = getSessionKey();
		// get map from cache
		var storage = cache.get( cacheKey );
		// Verify, else create it
		if( isNull( storage ) ){
			storage = { "sessionid" : cachekey, "timecreated" : now() };
			cache.set( cacheKey, storage, variables.timeout, 0 );
		}

		return storage;
	}

	/**
	* Remove the bucket
	*/
	CacheStorage function removeStorage(){
		cache.clear( getSessionKey() );
		return this;
	}

	/**
	* Check if storage exists
	*/
	boolean function storageExists(){
		return cache.lookup( getSessionKey() );
	}

	/**
	* Builds the unique Session Key of a user request
	*/
	private string function getSessionKey(){
		var prefix = "cbstorage:#variables.appName#:";

		// Check jsession id First
		if( isDefined( "session" ) and structKeyExists( session, "sessionid" ) ){
			return "cbstorage:" & session.sessionid;
		}
		// Check normal cfid and cftoken in cookie
		else if( structKeyExists( cookie, "CFID" ) AND structKeyExists( cookie,"CFTOKEN" ) ){
			return prefix & hash( cookie.cfid & cookie.cftoken );
		}
		// Check normal cfid and cftoken in URL
		else if( structKeyExists( URL, "CFID" ) AND structKeyExists( URL,"CFTOKEN" ) ){
			return prefix & hash( URL.cfid & URL.cftoken );
		}
		// check session URL Token
		else if( isDefined( "session" ) and structKeyExists( session, "URLToken" ) ){
			return prefix & session.URLToken;
		} else {
			throw( 
				message = "Cannot find a jsessionid, URLToken or cfid/cftoken in any scope. Please verify",
				type 	= "CacheStorage.UniqueKeyException"
			);
		}
	}

}