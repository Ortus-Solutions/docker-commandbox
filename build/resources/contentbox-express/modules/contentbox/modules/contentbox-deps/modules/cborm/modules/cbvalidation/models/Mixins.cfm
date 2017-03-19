<cfscript>

/**
* Validate an object or structure according to the constraints rules.
* @target An object or structure to validate
* @fields The fields to validate on the target. By default, it validates on all fields
* @constraints A structure of constraint rules or the name of the shared constraint rules to use for validation
* @locale The i18n locale to use for validation messages
* @excludeFields The fields to exclude in the validation
* 
* @return cbvalidation.model.result.IValidationResult
*/
function validateModel(
	required any target,
	string fields="*",
	any constraints,
	string locale="",
	string excludeFields=""
){
	return getValidationManager().validate( argumentCollection=arguments );
}

/**
* Retrieve the application's configured Validation Manager
*/
function getValidationManager(){
	return wirebox.getInstance( "ValidationManager@cbvalidation" );	
} 

</cfscript>