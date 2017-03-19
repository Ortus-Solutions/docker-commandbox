/**
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component accessors="true"{

	/**
	* The ForgeBox Endpoint URL
	*/
	property name="endpointURL";

	/**
	* The ForgeBox API version to use
	*/
	property name="version" default="1";

	// Static Order Entries
	this.ORDER = {
		POPULAR = "popular",
		NEW 	= "new",
		RECENT 	= "recent"
	};

	/**
	* Constructor
	* @endpointURL Override the Forgebox Endpoint URL
	* @version Override the version to use, defaults to latest: v1
	*/
	function init( endpointURL = "https://www.forgebox.io", version="v1" ){
		variables.endpointURL 	= arguments.endpointURL;
		variables.version 		= arguments.version;

		return this;
	}

	/**
	* Gets the API URL according to properties: ex: https://www.forgebox.io/api/v1
	*/
	function getAPIURL(){
		return variables.endpointURL & "/api/" & variables.version;
	}

	/**
	* Pings the API to see if its alive
	*/
	string function ping(){
		var results = makeRequest( resource="echo" );
		// error 
		if( results.error ){
			throw( "Error making ForgeBox REST Call", results.message );
		}
		return arrayToList( results.response.messages );
	}

	/**
	* Get the entry types as array of structs
	*/
	array function getTypes(){
		var results = makeRequest( resource="types" );
		// error 
		if( results.error ){
			throw( "Error making ForgeBox REST Call", results.message );
		}
		return results.response.data;		
	}

	/**
	* Get a type representation
	*/
	struct function getType( required slug ){
		var results = makeRequest( resource="types/#arguments.slug#" );
		// error 
		if( results.error ){
			throw( "Error making ForgeBox REST Call", results.message );
		}
		return results.response.data;		
	}

	/**
	* Check if a slug is available
	*/
	boolean function isSlugAvailable( required slug ){
		var results = makeRequest( resource="slug-check/#arguments.slug#" );
		// error 
		if( results.error ){
			throw( "Error making ForgeBox REST Call", results.message );
		}
		return results.response.data;
	}

	/**
	* Get entries
	* @orderBy The sort ordering, look at this.ORDER
	* @maxrows Used for pagination
	* @startRow Used for pagination
	* @typeSlug Filter by type
	* 
	* @results struct = { count:numeric, offset:numeric, results:array, totalRecords:numeric }
	*/
	struct function getEntries(
		orderBy = "#this.ORDER.POPULAR#",
		numeric maxrows = 0,
		numeric startRow = 1,
		typeslug=""
	){
		var results = "";
		var params = {
			orderBY = arguments.orderby,
			maxrows = arguments.maxrows,
			startrow = arguments.startrow,
			typeSlug = arguments.typeSlug	
		};
		
		// Invoke call
		results = makeRequest( resource="entries", parameters=params );
		// error 
		if( results.error ){
			throw( "Error making ForgeBox REST Call", results.message );
		}
		return results.response.data;
	}

	/**
	* Get a single entry data
	* @slug The slug to retrieve
	*/
	struct function getEntry( required slug ){
		var results = "";
		// Invoke call
		results = makeRequest( resource="entry/#arguments.slug#" );
		// error 
		if( results.error ){
			throw( "Error making ForgeBox REST Call", results.message );
		}
		return results.response.data;		
	}	

	/**
	* Get an entry's latest version
	* @slug The slug to retrieve
	*/
	struct function getLatestVersion( required slug ){
		var results = "";
		// Invoke call
		results = makeRequest( resource="entry/#arguments.slug#/latest" );
		// error 
		if( results.error ){
			throw( "Error making ForgeBox REST Call", results.message );
		}
		return results.response.data;		
	}			

	/************************************************ PRIVATE ************************************************/
	
	/**
	* Make a ForgeBox REST Call
	* @method The HTTP method call
	* @resource The resource to call
	* @body The body contents of the request
	* @headers Request headers
	* @paremeters Request parameters
	* @timeout Request Timeout
	* 
	* @results struct = { error:boolean, response:struct, message, reponseHeader:struct, rawResponse }
	*/
	private struct function makeRequest(
		string method = "GET",
		required string resource,
		body = "",
		struct headers = structNew(),
		struct parameters = structNew(),
		numeric timeout = 15
	){

		var results = { 
			error 			= false,
			response 		= {},
			message 		= "",
			responseheader 	= {},
			rawResponse 	= "",
			stacktrace		= ""
		};
		var HTTPResults = "";
		var param 		= "";
		var jsonRegex 	= "^(\{|\[)(.)*(\}|\])$";
		
		// Default Content Type
		if( NOT structKeyExists( arguments.headers, "content-type" ) ){
			arguments.headers[ "content-type" ] = "";
		}

		// Create HTTP object
		var oHTTP = new HTTP(
			method 			= arguments.method,
			url 			= "#getAPIURL()#/#arguments.resource#",
			charset 		= "utf-8",
			timeout 		= arguments.timeout,
			throwOnError 	= true
		);

		// Add Headers
		for( var thisHeader in arguments.headers ){
			oHTTP.addParam( type="header", name="#thisHeader#", value="#arguments.headers[ thisHeader ]#" );
		}

		// Add URL Parameters: encoded automatically by CF 
		for( var thisParam in arguments.parameters ){
			oHTTP.addParam( type="URL", name="#thisParam#", value="#arguments.parameters[ thisParam ]#" );
		}
		
		// Body
		if( len( arguments.body ) ){
			oHTTP.addParam( type="body", value="#arguments.body#" );
		}
		
		// Make the request
		try{
			var HTTPResults = oHTTP.send().getPrefix();

			// Set Results
			results.responseHeader 	= HTTPResults.responseHeader;
			results.rawResponse 	= HTTPResults.fileContent.toString();
			
			// Error Details found?
			results.message = HTTPResults.errorDetail;
			if( len( HTTPResults.errorDetail ) ){ results.error = true; }
			
			// Try to inflate JSON
			results.response = deserializeJSON( results.rawResponse, false );

			// Verify response error?
			if( results.response.error ){
				results.error 	= true;
				results.message = results.response.messages.toString();
			}

		} catch( Any e ) {
			results.error 		= true;
			results.message 	= e.message & e.detail;
			results.stacktrace 	= e.stacktrace;
		}
		
		return results;
	}	
}