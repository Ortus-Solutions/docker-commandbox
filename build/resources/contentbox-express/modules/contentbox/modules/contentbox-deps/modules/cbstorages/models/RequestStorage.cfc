<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************

Author   :  Eric Peterson, Mike Burt
Date     :  October 21, 2016
Description :
    This is a plugin that enables the setting/getting of request cycle variables in
    the request scope.

getVar(name,default):any
setVar(name,value):void
deleteVar(name):boolean
exists(name):boolean
clearAll():void
getStorage():struct
clearStorage():void

----------------------------------------------------------------------->
<cfcomponent hint="Request Storage plugin. It provides the user with a mechanism for request cycle data storage using the request scope."
             output="false"
             singleton>

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

    <cffunction name="init" access="public" returntype="RequestStorage" output="false">
        <cfscript>
            // Lock Properties
            instance.lockTimeout = 20;
            return this;
        </cfscript>
    </cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

    <!--- Set a variable --->
    <cffunction name="setVar" access="public" returntype="void" hint="Set a new request cycle variable." output="false">
        <!--- ************************************************************* --->
        <cfargument name="name"  type="string" required="true" hint="The name of the variable.">
        <cfargument name="value" type="any"    required="true" hint="The value to set in the variable.">
        <!--- ************************************************************* --->
        <cfset var storage = getStorage()>

        <cflock scope="request" type="exclusive" timeout="#instance.lockTimeout#" throwontimeout="true">
            <cfset storage[arguments.name] = arguments.value>
        </cflock>
    </cffunction>

    <!--- Get A Variable --->
    <cffunction name="getVar" access="public" returntype="any" hint="Get a new request cycle variable. If the variable does not exist. The method returns blank." output="false">
        <!--- ************************************************************* --->
        <cfargument  name="name"        type="string"  required="true"      hint="The variable name to retrieve.">
        <cfargument  name="default"     type="any"     required="false"     hint="The default value to set. If not used, a blank is returned." default="">
        <!--- ************************************************************* --->
        <cfset var storage = getStorage()>
        <cfset var results = "">

        <cflock scope="request" type="readonly" timeout="#instance.lockTimeout#" throwontimeout="true">
            <cfscript>
                if ( structKeyExists( storage, arguments.name) )
                    results = storage[arguments.name];
                else
                    results = arguments.default;
            </cfscript>
        </cflock>

        <cfreturn results>
    </cffunction>

    <!--- Delete a variable --->
    <cffunction name="deleteVar" access="public" returntype="boolean" hint="Tries to delete a request cycle var." output="false">
        <!--- ************************************************************* --->
        <cfargument  name="name" type="string" required="true"  hint="The variable name to retrieve.">
        <!--- ************************************************************* --->
        <cfset var results = false>
        <cfset var storage = getStorage()>

        <cflock scope="request" type="exclusive" timeout="#instance.lockTimeout#" throwontimeout="true">
            <cfset results = structdelete(storage, arguments.name, true)>
        </cflock>

        <cfreturn results>
    </cffunction>

    <!--- Exists check --->
    <cffunction name="exists" access="public" returntype="boolean" hint="Checks wether the request cycle variable exists." output="false">
        <!--- ************************************************************* --->
        <cfargument  name="name" type="string" required="true"  hint="The variable name to retrieve.">
        <!--- ************************************************************* --->
        <cfif NOT isDefined("request") OR NOT structKeyExists(request,"cbStorage")>
            <cfreturn false>
        <cfelse>
            <cfreturn structKeyExists( getStorage(), arguments.name)>
        </cfif>
    </cffunction>

    <!--- Clear All From Storage --->
    <cffunction name="clearAll" access="public" returntype="void" hint="Clear the entire coldbox request storage" output="false">
        <cfset var storage = getStorage()>

        <cflock scope="request" type="exclusive" timeout="#instance.lockTimeout#" throwontimeout="true">
            <cfset structClear(storage)>
        </cflock>
    </cffunction>

    <!--- Get Storage --->
    <cffunction name="getStorage" access="public" returntype="any" hint="Get the entire storage scope" output="false" >
        <cfscript>
            // Verify Storage Exists
            createStorage();
            // Return it
            return request.cbStorage;
        </cfscript>
    </cffunction>

    <!--- remove Storage --->
    <cffunction name="removeStorage" access="public" returntype="void" hint="remove the entire storage scope" output="false" >
        <cflock scope="request" type="exclusive" timeout="#instance.lockTimeout#" throwontimeout="true">
            <cfset structDelete(request, "cbStorage")>
        </cflock>
    </cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

    <!--- Create Storage --->
    <cffunction name="createStorage" access="private" returntype="void" hint="Create the request storage scope" output="false" >
        <cfif isDefined("request") AND NOT structKeyExists(request, "cbStorage")>
            <!--- Create request Storage Scope --->
            <cflock scope="request" type="exclusive" timeout="#instance.lockTimeout#" throwontimeout="true">
                <cfif not structKeyExists(request, "cbStorage")>
                    <cfset request["cbStorage"] = structNew()>
                </cfif>
            </cflock>
        </cfif>
    </cffunction>

</cfcomponent>
