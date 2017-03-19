[![Build Status](https://travis-ci.org/coldbox-modules/cbox-bcrypt.svg?branch=master)](https://travis-ci.org/coldbox-modules/cbox-bcrypt)

# BCrypt Module

A ColdBox module for BCrypt. You can ready more about BCrypt here:

* http://en.wikipedia.org/wiki/Bcrypt
* http://codahale.com/how-to-safely-store-a-password/

## Requirements

* The module is designed for ColdBox 4.X applications and up.  

## BCrypt.jar
A compiled version (0.3) of jBCrypt is included in the `models/lib` directory.  You can update the version by following the steps below.

1. Download jBCrypt from http://www.mindrot.org/projects/jBCrypt/.
2. Compile `BCrypt.java` to a `.class` file named `BCrypt.class`.
3. Package `BCrypt.class` into a jar file named `BCrypt.jar`.

## Installing BCrypt Module
Download the BCrypt module and place it in your `modules` folder.  Even easier, is isntall via CommandBox and this will also isntall the required JavaLoader module as well

```bash
box install bcrypt
```


## BCrypt WireBox Mapping

This module will automatically register a model called `BCrypt@BCrypt` that you inject via WireBox injection DSL:

```js
property name="BCrypt" inject="BCrypt@BCrypt";
```

or via `getModel()` inside your handlers, views, interceptors, etc.

```js
getModel( "BCrypt@BCrypt" )
```

## Using BCrypt Module

BCrypt is best used to hash passwords only.  It's too slow (the point) to use as a simple digest.  It's not reversible, so it's not suitable for encrypting transmission data.

### Generating a password hash

The hashed password should be persisted so candidate passwords (submitted from login) can be checked against.

```js
var hashedPassword = getModel( "BCrypt@BCrypt" ).hashPassword( plaintextPassword );
```
    
### Checking a password hash

The `plaintextPasswordCandidate` is the password the user submits for authentication.  The hashed password is retrieved for the user being authenticated.

```js
var isSamePassword = getModel( "BCrypt@BCrypt" ).checkPassword( plaintextPasswordCandidate, hashedPassword );
```

### Configuring WorkFactor

`WorkFactor` is an input to BCrypt that controls how long (generally) it takes to hash a password.  The module sets a default value of `12`.  You should experiment to find the optimal value for your environment.  It should take as long as possible to hash a password without being burdensome to your users on login.  Half a second to a full second is generally a good target to shoot for.

You can also set the workFactor on a per-call basis by passing it in as a second parameter to the `hashPassword` method like so:

```js
var hashedPassword = getModel( "BCrypt@BCrypt" ).hashPassword( plaintextPassword, 7 );
```

### BCrypt Settings

You may override the default work factor by creating a `BCrypt` settings struct in your `ColdBox.cfc`.  The available settings can be found below:


```js
BCrypt = {
    workFactor = 12
};
```

