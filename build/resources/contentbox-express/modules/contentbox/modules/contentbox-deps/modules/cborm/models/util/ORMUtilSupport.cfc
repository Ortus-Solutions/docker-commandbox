/**
********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Author      :	Luis Majano & Mike McKellip
* Description :
* 
* This implementation supports multiple DSNs for ORM a-la Adobe ColdFusion 9
*/
component{

	/**
	* Flush a datasource
	*/
	public void function flush( string datasource ){
		if( StructKeyExists( arguments, "datasource" ) )
			ORMFlush( arguments.datasource );
		else
			ORMFlush();
	}

	/**
	* Get session
	*/
	public any function getSession( string datasource ){
		if( StructKeyExists( arguments, "datasource" ) )
			// get actual session from coldfusion.orm.hibernate.SessionWrapper
			return ORMGetSession( arguments.datasource ).getActualSession();
		else
			// get actual session from coldfusion.orm.hibernate.SessionWrapper
			return ORMGetSession().getActualSession();
	}

	/**
	* Get session factory
	*/
	public any function getSessionFactory( string datasource ){
		if( StructKeyExists( arguments, "datasource" ))
			return ORMGetSessionFactory( arguments.datasource );
		else
			return ORMGetSessionFactory();
	}

	/**
	* Clear a session
	*/
	public void function clearSession( string datasource ){
		if( StructKeyExists( arguments, "datasource" ))
			ORMClearSession( arguments.datasource );
		else
			ORMClearSession();
	}

	/**
	* Close a session
	*/
	public void function closeSession( string datasource ){
		if( StructKeyExists( arguments, "datasource" ))
			ORMCloseSession( arguments.datasource );
		else
			ORMCloseSession();
	}

	/**
	* Evict queries
	*/
	public void function evictQueries( string cachename, string datasource ){
		if(StructKeyExists( arguments,"cachename" ) AND  StructKeyExists( arguments, "datasource" ))
			ORMEvictQueries( arguments.cachename, arguments.datasource );
		else if( StructKeyExists( arguments,"cachename" ) )
			ORMEvictQueries( arguments.cachename );
		else
			ORMEvictQueries();
	}

	/**
 	* Returns the datasource for a given entity
 	* @entity The entity reference. Can be passed as an object or as the entity name.
 	*/
 	public string function getEntityDatasource( required entity ){
 		// DEFAULT datasource
 		var datasource = getDefaultDatasource();

 		if( !IsObject( arguments.entity ) ) arguments.entity= EntityNew( arguments.entity );

 		var md = getMetaData( arguments.entity );
 		if( structKeyExists( md, "datasource" ) ) datasource = md.datasource;

 		return datasource;
 	}

 	/**
	* Get the default application datasource
	*/
 	public string function getDefaultDatasource(){
 		// get application metadata
 		if( listFirst( server.coldfusion.productVersion, "," ) gte 10 ){
			var settings = getApplicationMetadata();
		} else {
			var settings = application.getApplicationSettings();
		}

 		// check orm settings first
 		if( structKeyExists( settings, "ormsettings" ) AND structKeyExists( settings.ormsettings,"datasource" ) ){
 			return settings.ormsettings.datasource;
 		}

 		// else default to app datasource
 		return settings.datasource;
 	};

}
