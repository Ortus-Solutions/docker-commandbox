/********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
********************************************************************************
* The ORM WireBox DSL
*/
component implements="coldbox.system.ioc.dsl.IDSLBuilder" accessors="true"{

	property name="injector";
	property name="log";


	/**
	* Constructor as per interface
	*/
	public any function init( required any injector ) output="false"{
		variables.injector 	= arguments.injector;
		variables.log		= arguments.injector.getLogBox().getLogger( this );

		return this;
	}

	/**
	* Process an incoming DSL definition and produce an object with it.
	*/
	public any function process( required definition, targetObject ) output="false"{
		var DSLNamespace = listFirst( arguments.definition.dsl, ":" );
		switch( DSLNamespace ){
			case "entityService" : { return getEntityServiceDSL( argumentCollection=arguments );}
		}
	}

	/**
	* Get an EntityService Dependency
	*/
	function getEntityServiceDSL( required definition, targetObject ){
		var entityName  = getToken( arguments.definition.dsl, 2, ":" );

		// Do we have an entity name? If we do create virtual entity service
		if( len( entityName ) ){
			return new cborm.models.VirtualEntityService( entityName );
		}

		// else return Base ORM Service
		return new cborm.models.BaseORMService();
	}

}