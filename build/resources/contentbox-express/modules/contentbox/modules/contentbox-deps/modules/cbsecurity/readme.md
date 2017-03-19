[![Build Status](https://travis-ci.org/ColdBox/cbox-security.svg?branch=development)](https://travis-ci.org/ColdBox/cbox-security)

#WELCOME TO THE COLDBOX SECURITY MODULE

This module will provide your application with a security rule engine. For more information visit the documentation here: https://github.com/ColdBox/cbox-security/wiki

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- https://github.com/ColdBox/cbox-security
- http://www.coldbox.org/forgebox/view/cbsecurity
- https://github.com/ColdBox/cbox-security/wiki

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdFusion 9+

INSTRUCTIONS
============

Just drop into your **modules** folder or use CommandBox to install

`box install cbsecurity`

You will then need to configure the interceptor via the `cbsecurity` settings in your main `ColdBox.cfc` or you can also declare the interceptor manually by leveraging the class: `cbsecurity.interceptors.Security`.  If you define the `cbsecurity` settings, then the module will load the interceptor automatically for you with those settings.

You can find all the documentation here: https://github.com/ColdBox/cbox-security/wiki

## Security Rules
Security rules can come from xml, json, query, memory or custom locations.  You will find some examples in this module's `config` folder.

## Settings
Below are the security settings you can use for this module. Remember you must create the `cbsecurity` struct in your `ColdBox.cfc`:

```js
cbsecurity = {
    // By default all rules are evulated as regular expressions
    useRegex = true,
    // Verify queries that they have all required columns, by default it is relaxed
    queryChecks = false,
    // Will verify rules of execute before ANY event. Be careful, can be intensive, usually the preProcess is enough.
    preEventSecurity = false,
    // The class path of a CFC that will validate rules, optional
    validator = "class.path",
    // The WireBox ID of the object to validate rules, optional
    validatorModel = "wireboxID",
    // The bean ID of the object in the ioc module that will validate the rules, optional
    validatorIOC = "beanID.from.ioc.module",
    // Where to look for security rules
    rulesSource = "xml,json,db,model,ioc,ocm",
    // The location of a rules file, aplies to XML and JSON only
    rulesFile = "path.to.file",
    // Rules DB Properties
    rulesDSN = "datasource",
    rulesTable = "table",
    rulesSQL = "select * from rulesTable",
    rulesOrderBy = "",
    // Model Rule Properties
    rulesModel = "wirebox.id",
    rulesModelMethod = "method",
    rulesModelArgs = "comma-delimmited list of args",
    // IOC properties
    rulesBean = "bean.id",
    rulesBeanMethod = "method",
    rulesBeanArgs = "comma-delimmited list of args",
    // Cache key that has rules in the 'default' provider
    rulesOCMKey = "key.from.default.provider"
}
```

## Manual Interceptor Declaration
Here is a sample declaration you can use in your `ColdBox.cfc`:

```
// Security Interceptor declaration.
interceptors = [
    { class="cbsecurity.interceptors.Security",
      name="CBSecurity",
      properties={
        // please add the properties you want here to configure the security interceptor
        rulesFile = "/cbsecurity/config/security.json.cfm",
        rulesSource = "json"
     } }
];
```

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
####HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12