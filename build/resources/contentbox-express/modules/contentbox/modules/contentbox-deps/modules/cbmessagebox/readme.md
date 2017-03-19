[![Build Status](https://travis-ci.org/coldbox-modules/cbox-messagebox.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbox-messagebox)

# WELCOME TO THE MESSAGEBOX MODULE
A nice producer of flash scoped based messages that's skinnable

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- https://github.com/coldbox-modules/cbox-messagebox
- https://forgebox.io/view/cbmessagebox
- [Changelog](changelog.md)

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdFusion 10+

# INSTRUCTIONS
Just drop into your **modules** folder or use CommandBox to install

`box install cbmessagebox`

## WireBox Mappings
The module registers the MessageBox model: `messagebox@cbmessagebox` that you can use to emit messages. Check out the API Docs for all the possible functions.

## Settings
You can use the MessageBox as is with the current skin or use the functions or settings to overide styles and skinning.  You must place the settings in your `ColdBox.cfc` file under a `messagebox` struct:

```js
messagebox = {
    // The default HTMl template for emitting the messages
	template 		= "#moduleMapping#/views/MessageBox.cfm",
    // Override the internal styles, true to override
	styleOverride 	= false
};
```

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
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