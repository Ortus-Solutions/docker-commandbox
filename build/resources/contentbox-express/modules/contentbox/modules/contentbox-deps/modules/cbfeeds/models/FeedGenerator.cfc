<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author      :	Ben Garrett and Luis Majano
Date        :	18/05/2009
Version     :	2
License		: 	Apache 2 License
Description :
	This is a feed generator. It is able to output RSS 2.0 feeds
	You need to set the following settings in your application (coldbox.xml.cfm)

METHODS:

	- CreateFeed( feedStruct:struct, [ColumnMap:struct] [OutputFile:string] [OutputXML:boolean] ): XML or Boolean

	  This method will create the feed and return it to the caller in XML format.
	  * feedStruct : The properties and items structure.
	  * ColumnMap : You create a structure that will map the RSS elements to your query.
	  * OutputFile : The file path of where to write the feed to.
	  * OutputXML : Boolean (default:false) display generated XML on screen.

	- getDefaultPropertyMap(): Struct

	  This method creates a structure listing of all the default property maps for dumping.

	- parseColumnMap( columnMap:struct ): Struct

	  This method parses and validates a supplied column map, returning the results for dumping.
	  * columnMap : Column map structure (see below).

----------------------------------------------------------------------->
<cfcomponent hint="A feed generator plug-in. Currently this plug-in only generates RSS 2.0 feeds."
			 singleton>

<!---------------------------------------- CONSTRUCTOR --------------------------------------------------->


	<cffunction name="init" access="public" returntype="FeedGenerator" output="false" hint="Plug-in constructor.">
		<cfset variables.extrasRSS2 	= createObject( 'component', 'util.RSS2Generator' ).init()>
		<cfset variables.extrasShared 	= createObject( 'component', 'util.SharedGenerator' ).init()>

		<cfreturn this>
	</cffunction>

<!---------------------------------------- PUBLIC METHODS ------------------------------------------------>

	<!--- Create feed --->
	<cffunction name="createFeed" access="public" returntype="any" hint="Create a web feed, by default it returns the xml string." output="false">
		<!--- ******************************************************************************** --->
		<cfargument name="feedStruct" 	type="struct"  required="yes" hint="The structure used to build a feed"/>
		<cfargument name="ColumnMap" 	type="struct"  default="#structNew()#" hint="The column mapper to wire items to queries"/>
		<cfargument name="OutputFile" 	type="string"  required="false" hint="The file destination of where to store the generated XML (optional)"/>
		<cfargument name="OutputXML"	type="boolean" required="false" hint="Toggle to display the XML output on-screen delivered by cfcontent (optional)"/>
		<!--- ******************************************************************************** --->
		<cfscript>
			var fs = arguments.feedStruct;
			var cm = arguments.ColumnMap;
			var xmlContent = "";
			var xmlCleaned = "";

			/* Append generator infomation to feed */
			fs["generator"] = "FeedGenerator";

			/* Force creation of RSS2 feeds (as it is the only format currently supported) */
			fs["feedformat"] = "rss2";

			/* Verify feed structure and data then generate XML source */
			if(fs.feedformat is 'rss2') {
				/* verify our structure */
				extrasRSS2.verifyFeed(fs,cm);
				/* generate XML source */
				xmlContent = extrasRSS2.generateChannel(fs,cm);
			}
			else if(fs.feedformat is 'atom') {}
			else if(fs.feedformat is 'rdf') {}

			/* Apply XSL formating to messy XML code */
			xmlCleaned = XMLTransform(xmlContent,extrasShared.XSLFormat());
		</cfscript>

		<!--- Check for and generate file output --->
		<cfif structKeyExists(arguments,"OutputFile")>
			<cffile action="write" file="#arguments.OutputFile#" output="#xmlCleaned#" charset="utf-8"/>
		</cfif>

		<!--- Check for and generate on-screen output --->
		<cfif structKeyExists(arguments, "OutputXML")>
			<cfcontent variable="#ToBinary(ToBase64(xmlCleaned))#" type="text/xml"/>
		</cfif>

		<!--- Always return xml --->
		<cfreturn xmlCleaned/>
	</cffunction>

<!---------------------------------------- ACCESSOR/MUTATORS --------------------------------------------->

	<!--- Parse column map --->
	<cffunction name="parseColumnMap" output="false" access="public" returntype="struct" hint="Parse and validate a column mapper">
		<!--- ******************************************************************************** --->
		<cfargument name="columnMap" type="struct" required="true" hint="The column map to parse"/>
		<!--- ******************************************************************************** --->
		<cfscript>
			var map = extrasShared.getDefaultPropertyMap(arguments.columnMap);
			return map;
		</cfscript>
	</cffunction>

	<!--- Get default property map --->
	<cffunction name="getDefaultPropertyMap" output="false" access="public" returntype="struct" hint="Get the default property map">
		<cfscript>
			var map = extrasRSS2.generateDefaultPropertyMap();
			/* Return map */
			return map;
		</cfscript>
	</cffunction>

</cfcomponent>