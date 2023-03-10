/**
* Description of task
*/
component {
	property name="repo";
	property name="apiToken";
	property name="baseURL";
	
	function run(
		required string repo,
		required string apiToken
	) {

		structAppend( variables, arguments, true );
		loadModule( 'modules/hyper' );
		variables.baseUrl = "https://api.github.com/repos/#variables.repo#/code-scanning/alerts";

		// Retreive the current alerts
		var hasActiveAlerts = true;

		while( hasActiveAlerts ){
			var response = wirebox.getInstance( "HyperBuilder@hyper" ).new()
								.setURL( variables.baseUrl )
								.setMethod( "GET" )
								.withHeaders( getRequestHeaders() )
								.withQueryParams( {
									"state" : "open",
									"sort" : "updated",
									"direction" : "asc",
									"per_page" : 100,
									"page" : 1
								} )
								.setThrowOnError( true )
								.asJSON()
								.send();
			if( response.getStatusCode() == 200 ){
				var alerts = response.json();
				if( !alerts.len() ){
					print.greenLine( 'No more alerts were found' );
					hasActiveAlerts = false;
					break;	
				} else {
					print.greenLine( 'Retrieved #alerts.len()# alerts' );
					alerts.each( dismissAlert );
				}
			} else {
				print.redLine( 'An . The message received was: #serializeJSON( response.json() )#' );
				return 1;
			}
		}

		return 0;
		
	}

	function getRequestHeaders(){
		return { 
			"Authorization" : "Bearer #variables.apiToken#",
			"Accept" : "application/vnd.github+json",
			"X-GitHub-Api-Version" : "2022-11-28"
		}
	}

	function dismissAlert( alert ){
		var response = wirebox.getInstance( "HyperBuilder@hyper" ).new()
									.setURL( variables.baseURL & "/" & alert.number )
									.setMethod( "PATCH" )
									.withHeaders( getRequestHeaders() )
									.setThrowOnError( true )
									.setBody(
										{
											"state" : "dismissed",
											"dismissed_reason" : "used in tests"
										}
									)
									.asJSON()
									.send();
		if( response.getStatusCode() == 200 ){
			print.greenLine( 'Alert #alert.number# successfully dismissed.' );
		} else {
			print.redLine( 'An error occurred while attempting to update the stack. The message received was: #serializeJSON( response.json() )#' );
			return 1;
		}
	}

}
