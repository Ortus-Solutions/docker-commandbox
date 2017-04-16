<cfsetting enablecfoutputonly="true"/>
<cfif structKeyExists( url, "debug" )>
	<cfscript>
		system = createObject( "java", "java.lang.System" );
		env = system.getenv();
	</cfscript>
	<cfheader name="Content-Type" value="application/json"/>
	<cfswitch expression="#url.debug#">
		<cfcase value="cgi">
			<cfset debugOutput = cgi>
		</cfcase>

		<cfcase value="server">
			<cfset debugOutput = server>			
		</cfcase>

		<cfcase value="env">
			<cfset debugOutput = env>	
		</cfcase>

		<cfcase value="all">
			<cfset debugOutput = { "server":SERVER, "CGI":CGI, "env":env }>	
		</cfcase>
		<cfdefaultcase>
			<cfset debugOutput = { "error":true, "message":"No debug parameter provided" }>
		</cfdefaultcase>
	</cfswitch>
	<cfoutput>#serializeJSON( debugOutput )#</cfoutput>
<cfelse>
	<cfoutput>
		<h1>CommandBox is up and Running on Docker</h1>
	</cfoutput>
</cfif>