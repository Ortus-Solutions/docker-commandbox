/**
********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
********************************************************************************
* @author Luis Majano <lmajano@ortussolutions.com>
* The ColdBox Mail Service used to send emails in an oo and ColdBoxy fashion
*/
component accessors="true" singleton{

	property name="tokenMarker";
	property name="mailSettings";

	/**
	* Constructor
	* @mailSettings A structure of mail settings and protocol to bind this service with. A MailSettingsBean object is created with it.
	* @tokenMarker The default token Marker Symbol
	*/
	MailService function init( struct mailSettings={}, string tokenMarker="@" ){
		// Mail Token Symbol
		variables.tokenMarker = arguments.tokenMarker;
		
		// Mail Settings setup
		variables.mailSettings = new MailSettingsBean( argumentCollection=arguments.mailSettings );
		
		return this;
	}

	/**
	* Get a new Mail payload object, just use config() on it to prepare it or pass in all the arguments via this method
	*/
	Mail function newMail(){
		var mail = new cbmailservices.models.Mail( argumentCollection=arguments );
		
		// If mail payload does not have a server and one is defined in the mail settings, use that
		if( NOT mail.propertyExists( "server" ) AND len( variables.mailSettings.getServer() ) ){
			mail.setServer( variables.mailSettings.getServer() );
		}
		// Same with username, password, port, useSSL and useTLS
		if( NOT mail.propertyExists( "username" ) AND len( variables.mailSettings.getUsername() ) ){
			mail.setUsername( variables.mailSettings.getUsername() );
		}
		if( NOT mail.propertyExists( "password" ) AND len( variables.mailSettings.getPassword() ) ){
			mail.setPassword( variables.mailSettings.getPassword() );
		}
		if( NOT mail.propertyExists( "port" ) AND len( variables.mailSettings.getPort() ) and variables.mailSettings.getPort() NEQ 0 ){
			mail.setPort( variables.mailSettings.getPort() );
		}
		if( NOT mail.propertyExists( "useSSL" )  AND len( variables.mailSettings.getValue( "useSSL", "" ) ) ){
			mail.setUseSSL( variables.mailSettings.getValue( "useSSL" ) );
		}
		if( NOT mail.propertyExists( "useTLS" )  AND len( variables.mailSettings.getValue( "useTLS", "" ) ) ){
			mail.setUseTLS( variables.mailSettings.getValue( "useTLS" ) );
		}
		// set default mail attributes if the variables.MailSettings bean has values
		if( NOT len(mail.getTo()) AND len( variables.mailSettings.getValue( "to", "" ) ) ){
			mail.setTo( variables.mailSettings.getValue( "to" ) );
		}
		if( NOT len(mail.getFrom()) AND len( variables.mailSettings.getValue( "from", "" ) ) ){
			mail.setFrom( variables.mailSettings.getValue( "from" ) );
		}
		if( ( NOT mail.propertyExists( "bcc" ) OR NOT len( mail.getBcc() ) ) AND len( variables.mailSettings.getValue( "bcc", "" ) ) ){
			mail.setBcc( variables.mailSettings.getValue( "bcc" ) );
		}
		if( ( NOT mail.propertyExists( "replyto" ) OR NOT len( mail.getReplyTo() ) ) AND len( variables.mailSettings.getValue( "replyto", "" ) ) ){
			mail.setReplyTo( variables.mailSettings.getValue( "replyto" ) );
		}
		if( ( NOT mail.propertyExists( "type" ) OR NOT len( mail.getType() ) ) AND len( variables.mailSettings.getValue( "type", "" ) ) ){
			mail.setType( variables.mailSettings.getValue( "type" ) );
		}
		
		return mail;
	}

	/**
	* Send an email payload. Returns a struct: [error:boolean, errorArray:array]
	* @mail The mail payload to send.
	*/
	struct function send( required Mail mail ){
		var rtnStruct 	 = structnew();
		var payload 	 = arguments.mail;
		
		// The return structure
		rtnStruct.error = true;
		rtnStruct.errorArray = ArrayNew(1);
			
		// Validate Basic Mail Fields
		if( NOT payload.validate() ){
			arrayAppend(rtnStruct.errorArray,"Please check the basic mail fields of To, From and Body as they are empty. To: #payload.getTo()#, From: #payload.getFrom()#, Body Len = #payload.getBody().length()#." );
			return rtnStruct;
		}
		
		// Parse Body Tokens
		parseTokens( payload );
				
		//Just mail the darned thing!!
		try{
			// We mail it using the protocol which is defined in the mail settings.
			rtnStruct = variables.mailSettings.getTransit().send(payload);
		}
		catch(Any e){
			ArrayAppend(rtnStruct.errorArray,"Error sending mail. #e.message# : #e.detail# : #e.stackTrace#");
		}

		return rtnStruct;
	}
	
	/**------------------------------------------- PRIVATE ------------------------------------------- **/
	
	/**
	* Parse the tokens and do body replacements.
	*/
	function parseTokens( required mail ){
		var tokens 		= arguments.mail.getBodyTokens();
		var body 		= arguments.mail.getBody();
		var mailParts	= arguments.mail.getMailParts();
  		var key 		= 0;
		var tokenMarker = getTokenMarker();
		var mailPart 	= 1;
		
		//Check mail parts for content
		if( arrayLen( mailparts ) ){
			// Loop over mail parts
			for(mailPart=1; mailPart lte arrayLen( mailParts ); mailPart++){
				body = mailParts[ mailPart ].body;
				for( key in tokens ){
					body = replaceNoCase( body, "#tokenMarker##key##tokenMarker#", tokens[ key ], "all" );
				}
				mailParts[ mailPart ].body = body;
			}
		}
		
		// Do token replacement on the body text
		for( key in tokens ){
			body = replaceNoCase( body, "#tokenMarker##key##tokenMarker#", tokens[ key ], "all" );
		}
		
		// replace back the body
		arguments.mail.setBody( body );
	}

}