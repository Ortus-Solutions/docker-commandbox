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
			<cfset debugOutput = { "error":true, "message":"No debug parameter provided. Available parameters are: cgi, server, env, all" }>
		</cfdefaultcase>
	</cfswitch>
	<cfoutput>#serializeJSON( debugOutput )#</cfoutput>
<cfelse>
	<body style="background-color: ##efefef; margin-top:100px">
		<h1>
			<div style="text-align: center">
				<img src="CommandBoxLogo300.png" > <br>
				Is up and Running on Docker!
			</div>
		</h1>
		<p style="text-align: center">
			If you want to see some debugging information for this instance, click on the debug link: <a href="index.cfm?debug=true">see debugging</a>
		</p>
	</body>
</cfif>