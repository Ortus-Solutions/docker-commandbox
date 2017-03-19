/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Author      :	Luis Majano & Mike McKellip
* Description :
* 
* This implementation supports multiple DSNs for ORM a-la Adobe ColdFusion 9
*/
component extends="cborm.models.util.ORMUtilSupport" implements="cborm.models.util.IORMUtil" {

	/**
	* Get hibernate session object
	* @override
	*/
	public any function getSession( string datasource ){
		return ( StructKeyExists( arguments,"datasource" ) ?  ORMGetSession( arguments.datasource ) : ORMGetSession() );
	}
}