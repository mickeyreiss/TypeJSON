# TypeJSON

A simple JSON parsing library that aims to adhere to the JSON spec with a sprinkle of type safety.

## Goals

* Keep in touch with the structure and limitations of JSON. It's [pretty simple](http://www.json.org/).
* Take advantage of the type-system to help avoid bugs without adding too much effort.
* Allow you to index into objects and arrays without performing type-checks at each step.

## Usage

### Parse some JSON

```objc
NSData *profileData = [@"{ \"name\": \"Mickey Mouse\", \"details\": { \"age\": 102, \"species\": \"mouse\" }, \"animated\": true, \"friends\": [\"Minnie\", \"Goofy\", \"Donald\"] }" dataUsingEncoding:NSUTF8StringEncoding];
JSON *profileJSON = [JSON fromData:data];
```

### Access values with subscript notation and type coersion

```objc
NSString *mickeysName = profileJSON["name"].asString;
BOOL isAnimated = profileJSON["animated"].isTrue;
NSInteger mickeysAge = profileJSON["details"]["age"].asNumber.integerValue;
NSString *mickeysSpecies = profileJSON["details"]["species"].asString;
NSString *mickeysFirstFriendsName = profileJSON["friends"][0].asString;
```

### Handle errors when data shape does not meet assumptions

```objc
JSON *minniesNameJSON = profileJSON["friends"][0]["name"]; // => JSON
NSString *minniesName = minniesNameJSON.asString; // => nil
NSError *minniesNameError = minniesNameJSON.asError; // => NSError(domain: JSON, code: 422)
NSString *mickeysLocation = profileJSON["location"].asError; // => NSError(domain: JSON, code: 404)
```

### Perform explicit type-checking when data type is not known in advance

```objc
profileJSON.isObject; // => YES
profileJSON["name"].isString // => YES
profileJSON["animated"].isString // => NO
profileJSON["animated"].isTrue // => YES
```

### Serialize values back to JSON data

```objc
NSData *profileData = profileJSON.asJSON; // => { "name": "Mickey Mouse", "details": { "age": 102, "species": "mouse" }, "animated": true, "friends": ["Minnie", "Goofy", "Donald"] } as NSData
NSData *detailsData = profileJSON["details"].asJSON; // => { "age": 102, "species": "mouse" } as NSData
```

### Create JSON from scratch

```objc
JSON *myJSON = [JSON emptyObject];
// TODO: Mutator methods
```

## Inspiration

* [swift-json](https://github.com/dankogai/swift-json/)

## License

Standard MIT license. Enjoy.
