/**
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* This Interceptor if activated automatically cleans the request collection for you
*/
component extends="coldbox.system.Interceptor"{

	// DI: This is a provider as it needs to javaloaded first
	property name="antisamy" inject="provider:AntiSamy@CBAntiSamy";

	// On request capture
	function onRequestCapture( event, interceptData, buffer ){
		// if not activated, just exist
		if( getSetting( "antisamy" ).autoClean == false ){ return; }
		// rc reference
		var rc = event.getCollection();
		// cleanup
		for( var key in rc ){
			if( structKeyExists( rc, key ) and isSimpleValue( rc[ key ] ) ){
				rc[ key ] = antiSamy.clean( rc[ key ] );
			}
		}
	}

}
