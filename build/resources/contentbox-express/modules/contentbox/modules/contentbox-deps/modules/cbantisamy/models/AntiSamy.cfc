/**
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* OWASP AntiSamy Project that provides XSS cleanup operations to ColdBox applications
* http://www.owasp.org/index.php/Category:OWASP_AntiSamy_Project
* http://code.google.com/p/owaspantisamy/downloads/list
*/
component singleton threadsafe{

	// DI
	property name="moduleSettings" 	inject="coldbox:setting:antisamy";
	property name="javaLoader"		inject="loader@cbjavaloader";

	/**
	* Constructor
	*/
	function init(){
		return this;
	}

	function onDIComplete(){
		variables.policies = {
			// AntiSamy policyfile
			'antisamy' 	= moduleSettings.libPath & "/antisamy-anythinggoes-1.4.4.xml",
			//Load eBay policyfile
			'ebay'	  	= moduleSettings.libPath & "/antisamy-ebay-1.4.4.xml",
			//Load myspace policyfile
			'myspace'  	= moduleSettings.libPath & "/antisamy-myspace-1.4.4.xml",
			//Load slashdot policyfile
			'slashdot' 	= moduleSettings.libPath & "/antisamy-slashdot-1.4.4.xml",
			//Load tinymce policyfile
			'tinymce' 	= moduleSettings.libPath & "/antisamy-tinymce-1.4.4.xml",
			// Custom Policy
			'custom'	= moduleSettings.customPolicy
		};
	}

	/**
	* clean HTML from XSS scripts using the AntiSamy project. The available policies are antisamy, ebay, myspace, slashdot, custom
	*/
	any function clean( required HTMLData, string policyFile="ebay", boolean resultsObject=false ){
		return HTMLSanitizer( argumentCollection=arguments );
	}

	/**
	* clean HTML from XSS scripts using the AntiSamy project. The available policies are antisamy, ebay, myspace, slashdot, custom
	* @HTMLData The html data to clean
	* @policyFile The policy file to use, by default it uses the ebay policy file
	* @resultsObject By default it just returns the cleaned HTML, but if this is true, it will return the actual Java results object.
	* 
	* @return HTMl data or an instance of org.owasp.validator.html.CleanResults
 	*/
	any function HTMLSanitizer( required HTMLData, string policyFile="ebay", boolean resultsObject=false ){
		// you can use any xml, our your own customised policy xml
		var antiSamy = javaLoader.create( "org.owasp.validator.html.AntiSamy" );
		
		// validate policy file
		if( NOT structKeyExists( variables.policies, arguments.policyFile) ){
			throw( message="Invalid Policy File: #arguments.policyFile#",
				   detail="The available policy files are #structKeyList( variables.policies )#",
				   type="AntiSamy.InvalidPolicyException" );
		}
		
		// Clean with policy
		var cleanedHtml	= antiSamy.scan( arguments.htmlData, variables.policies[ arguments.policyFile ] );
		
		// returning results object or just clean HTML?
		if( arguments.resultsObject ){
			return cleanedHtml;
		} 
		
		return cleanedHTML.getCleanHTML();
	}
	
}