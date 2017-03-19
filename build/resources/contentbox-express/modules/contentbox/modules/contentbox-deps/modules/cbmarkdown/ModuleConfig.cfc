/**
* Ortus Markdown Module
* Copyright 2013 Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Module Configuration
*/
component {

	// Module Properties
	this.title 				= "ColdBox Markdown Processor";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com/products/codexwiki";
	this.description 		= "Markdown processor for ColdBox applications";
	this.version			= "2.0.0+00007";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbmarkdown";
	// CF Mapping
	this.cfmapping			= "cbmarkdown";
	// Module Dependencies That Must Be Loaded First, use internal names or aliases
	this.dependencies		= [ "cbjavaloader" ];

	/**
	* Configure this module
	*/
	function configure(){
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Class load MarkdownJ Processor
		controller.getWireBox()
			.getInstance( "loader@cbjavaloader" )
			.appendPaths( modulePath & "/models/lib" );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

}