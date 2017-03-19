/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Author      :	Luis Majano & Mike McKellip
* Description :
* 
* A simple factory to return the right ORM utility according to CFML engine
*/
import cborm.models.util.*;

component{

	/**
	* Get the ORM Utility object
	* @return IORMUtil
	*/
	public any function getORMUtil() {
		// Adobe ColdFusion
		if( getPlatform() == "ColdFusion Server" ){
			return new CFORMUtil();
		}
		// Lucee >= 4.5 MultiDatasource Support
		if( getPlatform() == "Lucee" ){
			return new LuceeORMUtil();
		}
		// Railo >= 4.3
		return new ORMUtil();
	}

	/**
	* Get platform name
	*/
	private string function getPlatform() {
		return server.coldfusion.productname;
	}

	/**
	* Get lucee version
	*/
	private string function getLuceeVersion() {
		return server.lucee.version;
	}

}