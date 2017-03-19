/*
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* --- 
* Simple interceptor to process logging of proposed SQL strings from criteria Builder object
*/ 
component extends="coldbox.system.Interceptor"{

    /**
     * Configuration method for interceptor
     */
    function configure(){
    }

    /**
    * Listen to criteria builder additions
    */
    function onCriteriaBuilderAddition( required event, required interceptData ){
        if( structKeyExists( interceptData, "CriteriaBuilder" ) ) {
            if( interceptData.CriteriaBuilder.canLogSql() ) {
                interceptData.CriteriaBuilder.logSql( label=interceptData.type );
            }
        }
    }
}