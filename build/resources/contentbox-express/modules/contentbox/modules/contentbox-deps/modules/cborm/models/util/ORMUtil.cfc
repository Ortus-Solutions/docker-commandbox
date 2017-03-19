/**
* ********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Author      :	Luis Majano & Mike McKellip
* Description :
* 
* This is the Railo implementation for single datasource support
*/
component implements="cborm.models.util.IORMUtil"{

	/**
	* Flush a datasource
	*/
	public void function flush( string datasource ){
		ORMFlush();
	}

	/**
	* Get session
	*/
	public any function getSession( string datasource ){
		return ORMGetSession();
	}

	/**
	* Get session factory
	*/
	public any function getSessionFactory( string datasource ){
		return ORMGetSessionFactory();
	}

	/**
	* Clear a session
	*/
	public void function clearSession( string datasource ){
		ORMClearSession();
	}

	/**
	* Close a session
	*/
	public void function closeSession( string datasource ){
		ORMCloseSession();
	}

	/**
	* Evict queries
	*/
	public void function evictQueries(string cachename, string datasource) {
		if( StructKeyExists( arguments,"cachename") )
			ORMEvictQueries( arguments.cachename );
		else
			ORMEvictQueries();
	}

	/**
 	* Returns the datasource for a given entity
 	* @entity The entity reference. Can be passed as an object or as the entity name.
 	*/
 	public string function getEntityDatasource(required entity) {
 		return getDefaultDatasource();
 	}

 	/**
	* Get the default application datasource
	*/
 	public string function getDefaultDatasource(){
 		var settings = application.getApplicationSettings();
 		// check orm settings first
 		if( structKeyExists( settings,"ormsettings") AND structKeyExists(settings.ormsettings,"datasource")){
 			return settings.ormsettings.datasource;
 		}
 		// else default to app datasource
 		return settings.datasource;
 	};

}