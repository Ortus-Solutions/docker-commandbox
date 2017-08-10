/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ColdBox Configuration
*/
component{

	// Configure ColdBox Application
	function configure(){

		var system 		= createObject( "java", "java.lang.System" );
		var systemEnv 	= system.getenv();

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 					= "ContentBox Modular CMS",

			//Development Settings
			reinitPassword				= structKeyExists( systemEnv, "FWREINIT_PW") ? systemEnv[ "FWREINIT_PW" ] : "@fwPassword@",
			handlersIndexAutoReload 	= false,

			//Implicit Events
			defaultEvent				= "Main.index",
			requestStartHandler			= "",
			requestEndHandler			= "",
			applicationStartHandler 	= "",
			applicationEndHandler		= "",
			sessionStartHandler 		= "",
			sessionEndHandler			= "",
			missingTemplateHandler		= "",

			//Extension Points
			applicationHelper 			= "",
			viewsHelper					= "",
			modulesExternalLocation		= [ "/modules_app" ],
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "",
			controllerDecorator			= "",

			//Error/Exception Handling
			exceptionHandler			= "",
			onInvalidEvent				= "",
			customErrorTemplate			= "",

			//Application Aspects
			handlerCaching 				= true,
			eventCaching				= true,
			viewCaching 				= true
		};

		// custom settings
		settings = {

		};
		
		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				console = { class="coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" }
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "",
			defaultView   = ""
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		// ORM Module Configuration
		orm = {
			// Enable Injection
			injection = {
				enabled = true
			}
		};

		//Register interceptors as an array, we need order
		interceptors = [
			//SES
			{ class="coldbox.system.interceptors.SES" }
		];

		// Choose a distributed cache
		var distributedCache = structKeyExists( systemEnv, "DISTRIBUTED_CACHE" ) ? systemEnv[ "DISTRIBUTED_CACHE" ] : "jdbc";
		
		// ContentBox relies on the Cache Storage for tracking sessions, which delegates to a Cache provider
		storages = {
		    // Cache Storage Settings
		    cacheStorage = {
		        cachename   = "sessions",
		        timeout     = 60 // The default timeout of the session bucket, defaults to 60
		    }
		};

		// ContentBox Runtime Overrides
		"contentbox" = {
			// Runtime Settings Override by site slug
		  	"settings" = {
		  		// Default site
		  		"default" = {
		  			// Distributed Cache For ContentBox
					"cb_content_cacheName"   = distributedCache,
					"cb_rss_cacheName"       = distributedCache,
					"cb_site_settings_cache" = distributedCache
		  		}
		  	}
		}

		// Distributed Cache Flash, only in non installer mode
		if( !structKeyExists( systemEnv, "installer" ) && !structKeyExists( systemEnv, "install" ) ){
			flash = {
			    scope = "cache",
			    properties = {
			    	cacheName = distributedCache
			    },
			    inflateToRC = true,
			    inflateToPRC = false,
			    autoPurge = true,
			    autoSave = true
			};
		}

		// Distributed Cache Storage
		storages = {
		    // Cache Storage Settings
		    cacheStorage = {
		        cachename   = distributedCache,
		        timeout     = 120
		    }
		};

	}

	// ORTUS DEVELOPMENT ENVIRONMENT, REMOVE FOR YOUR APP IF NEEDED
	function development(){

		//coldbox.debugmode=true;
		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching 			= false;
		coldbox.reinitpassword			= "";
		coldbox.customErrorTemplate 	= "/coldbox/system/includes/BugReport.cfm";

		// debugging file
		logbox.appenders.files = { 
			class="coldbox.system.logging.appenders.RollingFileAppender",
			properties = {
				filename = "ContentBox", filePath="/logs", async=true
			}
		};

		// Mail settings for writing to log files instead of sending mail on dev.
		mailsettings.protocol = {
			class = "cbmailservices.models.protocols.FileProtocol",
			properties = {
				filePath = "/logs"
			}
		};
		//logbox.debug 	= ["coldbox.system.interceptors.Security"];
		//logbox.debug 	= [ "coldbox.system.aop" ];
		//logbox.debug 	= [ "root" ];

	}

}
