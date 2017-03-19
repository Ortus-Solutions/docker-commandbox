[![Build Status](https://travis-ci.org/coldbox-modules/cbox-validation.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbox-validation)

WELCOME TO THE COLDBOX VALIDATION MODULE
========================================
ColdBox sports its own server side validation engine so it can provide you with a unified approach to object and form validation.

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- https://github.com/coldbox-modules/cbox-validation
- https://forgebox.io/view/validation
- https://github.com/coldbox-modules/cbox-validation/wiki

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdFusion 10+

INSTRUCTIONS
============

Just drop into your **modules** folder or use the box-cli to install

`box install cbvalidation`

The module will register several objects into WireBox using the `@cbvalidation` namespace.  The validation manager is registered as `ValidationManager@cbvalidation`

## Mixins
The module will also register two methods in your handlers/interceptors/layouts/views

```js
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
function validateModel()

/**
* Retrieve the application's configured Validation Manager
*/
function getValidationManager()
```

## Settings
Here are the module settings you can place in your `ColdBox.cfc` by using the `validation` settings structure:

```js
validation = {
    // The third-party validation manager to use, by default it uses CBValidation.
    manager = "class path",
    // You can store global constraint rules here with unique names
    sharedConstraints = {
        name = {
            field = { constraints here }
        }
    }

}
```

You can read more about ColdBox Validation here: - https://github.com/coldbox-modules/cbox-validation/wiki

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