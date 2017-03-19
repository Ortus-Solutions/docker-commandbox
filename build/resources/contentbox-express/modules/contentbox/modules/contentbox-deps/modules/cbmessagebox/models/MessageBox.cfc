/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com 
* ---
* @author Luis Majano
* This module provides a way to track alert message boxes.  The user has several types of message types
* 1. Warn
* 2. Error
* 3. Info
* The messages and optional metadata will be stored in the application's Flash RAM storage.
* ---
* The look and feel of the messages can be altered by styles and cfml template settings.
*/
component accessors="true" singleton{

	/******************************************** DI ************************************************************/

	property name="flash" inject="coldbox:flash";

	/******************************************** PROPERTIES ************************************************************/

	/**
	* The flash message key to use in the flash RAM data struct
	*/
	property name="flashKey" type="string";

	/**
	* The flash data key to use in the flash RAM data struct
	*/
	property name="flashDataKey" type="string";

	/**
	* The default rendering template to use
	*/
	property name="template" type="string";

	/**
	* Flag to override styles when rendering
	*/
	property name="styleOverride" type="boolean" default="false";

	/**
	* The module root location
	*/
	property name="moduleRoot" type="string";

	/**
	* Constructor
	* @config The messagebox module configuration structure
	* @config.inject coldbox:setting:messagebox
	*/
	function init( required struct config ){
		// prepare properties
		variables.flashKey 			= "coldbox_messagebox";
		variables.flashDataKey 		= "coldbox_messagebox_data";
		variables.template			= arguments.config.template;
		variables.styleOverride 	= arguments.config.styleOverride;
		variables.moduleRoot		= arguments.config.moduleRoot;

		return this;
	}

	/**
	* Facade to setmessage with error type
	* @message The message to flash, mutually exclusive to the 'messageArray' argument.
	* @messageArray An array of messages to flash, mutually exclusive to the 'message' argument.
	*/
	MessageBox function error( message="", array messageArray ){
		arguments.type = "error";
		return setMessage( argumentCollection=arguments );
	}

	/**
	* Facade to setmessage with info type
	* @message The message to flash, mutually exclusive to the 'messageArray' argument.
	* @messageArray An array of messages to flash, mutually exclusive to the 'message' argument.
	*/
	MessageBox function info( message="", array messageArray ){
		arguments.type = "info";
		return setMessage( argumentCollection=arguments );
	}

	/**
	* Facade to setmessage with warn type
	* @message The message to flash, mutually exclusive to the 'messageArray' argument.
	* @messageArray An array of messages to flash, mutually exclusive to the 'message' argument.
	*/
	MessageBox function warn( message="", array messageArray ){
		return warning( argumentCollection=arguments );
	}

	/**
	* Facade to setmessage with warn type
	* @message The message to flash, mutually exclusive to the 'messageArray' argument.
	* @messageArray An array of messages to flash, mutually exclusive to the 'message' argument.
	*/
	MessageBox function warning( message="", array messageArray ){
		arguments.type = "warn";
		return setMessage( argumentCollection=arguments );
	}

	/**
	* Create a new MessageBox with a specific message and type
	* @type The message type, available types are: info, error, warn
	* @message The message to flash, mutually exclusive to the 'messageArray' argument.
	* @messageArray An array of messages to flash, mutually exclusive to the 'message' argument.
	*/
	MessageBox function setMessage( required type, message="", array messageArray ){
		var msg = {};

		// check message type
		if( isValidMessageType( arguments.type ) ){
			// Populate message
			msg.type 	= arguments.type;
			msg.message = arguments.message;

			// Do we have a message array to flatten?
			if( structKeyExists( arguments,"messageArray" ) AND arrayLen( arguments.messageArray ) ){
				msg.message = flattenMessageArray( arguments.messageArray );
			}

			// Flash it
			flash.put(
				name 		= variables.flashKey,
				value		= msg,
				inflateToRC	= false,
				saveNow 	= true,
				autoPurge 	= false
			);
		} else {
			throw(
				message = "The message type is invalid: #arguments.type#",
				detail 	= "Valid types are info,error or warn",
				type 	= "MessageBox.InvalidMessageType"
			);
		}

		return this;
	}

	/**
	* Appends a message to the messagebox data. If there is no message, then it sets the default type to info.
	* @message The message to append
	* @defaultType The default type to use if not passed. Defaults to 'info'
	*/
	MessageBox function append( required message, defaultType="info" ){
		// Do we have a message?
		if( isEmptyMessage() ){
			// Set default message
			setMessage( type=arguments.defaultType, message=arguments.message );
		} else {
			// Get Current Message
			var currentMessage = getMessage();
			// Append
			var newMessage = currentMessage.message & arguments.message;
			// Set it back
			setMessage( type=currentMessage.type, message=newMessage );
		}

		return this;
	}

	/**
	* Append an array of messages to the MessageBox. If there is no message, then it sets the default type to info.
	* @messageArray An array of messages to append
	* @defaultType The default type to use if not passed. Defaults to 'info'
	*/
	MessageBox function appendArray( required array messageArray, defaultType="info" ){
		// Do we have a message?
		if( isEmptyMessage() ){
			// Set default message
			setMessage( type=arguments.defaultType, messageArray=arguments.messageArray );
		} else {
			// Get Current Message
			var currentMessage = getMessage();
			// Append
			ArrayPrePend( arguments.messageArray, currentMessage.message );
			// Set it back
			setMessage( type=currentMessage.type, messageArray=arguments.messageArray );
		}

		return this;
	}

	/**
	* Prepend an array of messages to the MessageBox. If there is no message, then it sets the default type to info.
	* @messageArray An array of messages to prepend
	* @defaultType The default type to use if not passed. Defaults to 'info'
	*/
	MessageBox function prependArray( required array messageArray, defaultType="info" ){
		// Do we have a message?
		if( isEmptyMessage() ){
			// Set default message
			setMessage( type=arguments.defaultType, messageArray=arguments.messageArray );
		} else {
			// Get Current Message
			var currentMessage = getMessage();
			// Append
			arrayAppend( arguments.messageArray, currentMessage.message );
			// Set it back
			setMessage( type=currentMessage.type, messageArray=arguments.messageArray );
		}

		return this;
	}

	/**
	* Returns a structure of the messages if it exists, else a blank structure.
	* @return { type, message }
	*/
	struct function getMessage(){
		// Check flash
		if( flash.exists( variables.flashKey ) ){
			return flash.get( variables.flashKey );
		}

		// return empty messagebox.
		return { type = "", message = "" };
	}

	/**
	* Clears the message structure by deleting it from the session scope.
	*/
	MessageBox function clearMessage(){
		flash.remove( name=variables.flashKey, saveNow=true );
		return this;
	}

	/**
	* Checks wether the MessageBox is empty or not.
	*/
	boolean function isEmptyMessage(){
		var msgStruct = getMessage();

		if( msgStruct.type.length() eq 0 and msgStruct.message.length() eq 0 ){
			return true;
		}
		return false;
	}

	/**
	* WARNING: Override the entire flash metadata key with your own array of data.
	* @theData The array of data to flash
	*/
	MessageBox function putData( required array theData ){
		// Flash it
		flash.put(
			name 		= variables.flashDataKey,
			value 		= arguments.theData,
			inflateToRC = false,
			saveNow		= true,
			autoPurge	= false
		);
		return this;
	}
	
	/**
	* Add metadata that can be used for saving arbitrary stuff alongside our flash messages
	* @key The key to store
	* @value The value to store
	*/
	MessageBox function addData( required key, required value ){
		var data 		= [];
		var tempStruct 	= {
			key = arguments.key, value = arguments.value
		};

		// Check flash
		if( flash.exists( variables.flashDataKey ) ){
			data = flash.get( variables.flashDataKey );
		}

		arrayAppend( data, tempStruct );

		// Flash it
		flash.put(
			name 		= variables.flashDataKey,
			value 		= data,
			inflateToRC = false,
			saveNow		= true,
			autoPurge	= false
		);
		return this;
	}
	
	/**
	 * Get the message data
	 * @clearData clear the data from flash or not.
	 */
	array function getData( boolean clearData=true ){
		var data = [];

		if( flash.exists( variables.flashDataKey ) ){
			data = flash.get( variables.flashDataKey );
		}

		// clear?
		if( arguments.clearData ){
			flash.remove( name=flashKey, saveNow=true );
		}

		return data;
	}

	/**
	 * Get the message data as js
	 * @clearData clear the data from flash or not.
	 */
	string function getDataJSON( boolean clearData=true ){
		return serializeJSON( getData( arguments.clearData ) );
	}

	/**
	* Renders the message box and clears the message structure by default
	* @clearMessage Flag to clear the message structure or not after rendering. Default is true.
	* @template An optional CFML template to use for rendering instead of core or setting
	*/
	function renderIt( boolean clearMessage=true, template="" ){
		var msgStruct 		= getMessage();
		var results 		= "";
		var thisTemplate 	= variables.template;

		// verify if the template is passed
		if( len( trim( arguments.template ) ) ){ 
			thisTemplate = arguments.template;
		}

		if( msgStruct.type.length() neq 0 ){
			savecontent variable="results"{
				include "#thisTemplate#";
			}
		}

		// clear?
		if( arguments.clearMessage ){
			flash.remove( name=flashKey, saveNow=true );
		}

		return results;
	}

	/**
	* Returns true if the message box contains a message of specified type
	* @type The message type, available types are: info, error, warn
	*/

	boolean function hasMessageType(
		required string type
	){
		// validate message type
		if (isValidMessageType( arguments.type )) {
			// don't bother checking for a message type if we don't have a message
			if (isEmptyMessage()) {
				return false;
			}
			else {
				var msgStruct = getMessage();
				return ((compareNoCase(msgStruct.type,arguments.type)) == 0) ? true : false; 
			}
		}
		else {
			throw(
				message = "Invalid message type: #arguments.type#",
				detail 	= "Valid types are info,warn,error",
				type 	= "MessageBox.InvalidType"
			);
		}
	}
	

	/**
	* Renders a messagebox immediately for you with the passed in arguments 
	* @type The message type, available types are: info, error, warn
	* @message The message to flash, mutually exclusive to the 'messageArray' argument.
	* @messageArray An array of messages to flash, mutually exclusive to the 'message' argument.
	* @template The CFML template to use to render the messagebox, if not passed then the one set as default will be used.
	*/
	string function renderMessage(
		required type,
		message="",
		messageArray,
		template=""
	){
		// default the variables
		var thisTemplate 	= variables.template;
		var msgStruct 	 	= { type="", message = "" };
		var results 		= "";

		// verify if the template is passed
		if( len( trim( arguments.template ) ) ){ 
			thisTemplate = arguments.template;
		}

		// Validate message type
		if( isValidMessageType( arguments.type ) ){
			msgStruct = { type = arguments.type, message = arguments.message };
		} else {
			throw(
				message = "Invalid message type: #arguments.type#",
				detail 	= "Valid types are info,warn,error",
				type 	= "MessageBox.InvalidType"
			);
		}

		// If message array passed, fflatten and save.
		if( structKeyExists( arguments, "messageArray") ){
			msgStruct.message = flattenMessageArray( arguments.messageArray );
		}

		// Render it out.
		savecontent variable="results"{
			include "#thisTemplate#";
		}

		return results;
	}

	/******************************************** PRIVATE ************************************************************/

	/**
	* Validate a type
	* @type The message type
	*/
	private boolean function isValidMessageType( required string type ){
		return refindnocase( "(error|warn|info)", trim( arguments.type ) ) ? true : false; 
	}

	/**
	* Flatten a message array into a string with <br> separators
	* @messageArray The message array to flatten.
	*/
	private string function flattenMessageArray( required array messageArray, string separator="<br>" ){
		var message = "";
		var i = 1;

		for( var item in arguments.messageArray ){
			message &= item;
			if( i neq arrayLen( arguments.messageArray ) ){
				message &= arguments.separator;
			}
			i++;
		}

		return message;
	}

}
