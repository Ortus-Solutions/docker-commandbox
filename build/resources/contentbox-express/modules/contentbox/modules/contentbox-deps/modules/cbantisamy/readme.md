[![Build Status](https://travis-ci.org/ColdBox/cbox-antisamy.svg?branch=development)](https://travis-ci.org/ColdBox/cbox-antisamy)

WELCOME TO THE ANTISAMY MODULE
==============================
OWASP AntiSamy Module that provides XSS cleanup operations to ColdBox 4 applications

* http://www.owasp.org/index.php/Category:OWASP_AntiSamy_Project
* http://code.google.com/p/owaspantisamy/downloads/list

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- Source: https://github.com/ColdBox/cbox-antisamy
- ForgeBox: http://forgebox.io/view/cbantisamy

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdFusion 9+

---

#Instructions
Just drop into your `modules` folder or use the box-cli to install

`box install cbantisamy`

# Usage
The module registers the following mapping in WireBox: `antisamy@cbantisamy`
that you can use to clean input a-la-carte intrusions.  You can also activate different policies and an auto clean interceptor that will clean incoming variables for you automatically.  The main methods to clean input are:

```javascript
/**
+ clean HTML from XSS scripts using the AntiSamy project. The available policies are antisamy, ebay, myspace, slashdot, custom
+ @HTMLData The html data to clean
+ @policyFile The policy file to use, by default it uses the ebay policy file
+ @resultsObject By default it just returns the cleaned HTML, but if this is true, it will return the actual Java results object.
+ 
+ @return HTMl data or an instance of org.owasp.validator.html.CleanResults
*/
any function clean( required HTMLData, string policyFile="ebay", boolean resultsObject=false )
```

## Settings
Here are the module settings you can place in your `ColdBox.cfc` under an `antisamy` structure

```js
// Antisamy settings
antisamy = {
    // Activate auto request capture cleanups interceptor
    autoClean = false,
    // Default Policy to use, available are: antisamy, ebay, myspace, slashdot and tinymce
    defaultPolicy = "ebay",
    // Custom Policy absolute path, leave empty if not used
    customPolicy = ""
};
```

You can read more about AntiSamy here: https://www.owasp.org/index.php/Category:OWASP_AntiSamy_Project

********************************************************************************
Copyright Since 2005 ColdBox Framework by Ortus Solutions, Corp
www.ortussolutions.com
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