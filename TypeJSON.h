#import <Foundation/Foundation.h>

extern NSString *TypeJSONErrorDomain;

///  Represents a JSON value, with an Objective-C interface that enables simple type-coersion and
///  tree-traversal.
@interface TypeJSON : NSObject

///  Parse UTF-8 JSON data as `JSON`.
///
///  @param object Valid JSON data
///
///  @return A JSON object based on the provided data or any errors encounter during parsing and initialization
+ (instancetype)fromData:(NSData *)object;

///  Creates a new JSON to represent the empty object, `{}`.
///
///  @return A new JSON instance
+ (instancetype)emptyObject;

#pragma mark Collection Accessors

///  Accesses the object located at the specified key, assuming the value to be an object.
///
///  If the value is not an object or if the key is not found, this method
///  will still succeed and return a `JSON` to represent the error.
///
///  If the value is already an error, the returned JSON will represent that same error.
///
///  @param index An index within the bounds of the array
///
///  @return A JSON either representing the indexed object or with an error
- (TypeJSON *)objectForKeyedSubscript:(NSString *)key;

///  Accesses the object located at the specified index, assuming the value to be an array.
///
///  If the value is not an array or if the index is out of bounds, this method
///  will still succeed and return a `JSON`.
///
///  If the value is already an error, the returned JSON will represent that same error.
///
///  @param index An index within the bounds of the array
///
///  @return A JSON either representing the indexed object or with an error
- (TypeJSON *)objectAtIndexedSubscript:(NSUInteger)index;

#pragma mark Value Accessors

///  Accesses the JSON value as a `string`.
///
///  @return Value as an `NSString`
- (NSString *)asString;

///  Accesses the JSON value as a `number`.
///
///  @return Value as an `NSDecimalNumber`
- (NSDecimalNumber *)asNumber;

///  Interprets the JSON value as either true or false.
///
///  Note that this is a convenience method; in JSON true and false are simply constant values,
///  which are not semantically related.
///
///  @return `YES` if the value is `true`, `NO` if the value is `false`, otherwise behavior is undefined
- (BOOL)asBool;

///  Accesses the JSON value as `null`, or nil if it is not nil.
///
///  Note the important differences between `nil` (Objective C language construct), `null` (JSON value) and `NSNull.null` (`Foundation` object) in this context.
///
///  @return NSNull.null or nil
- (NSNull *)asNull;

///  Accesses the JSON value as an `array`, with each value represented by a `JSON`, or nil if the value is not an array.
///
///  @return An array of _values_
- (NSArray *)asArray;

///  Access the JSON value as an `object`.
///
///  @return An NSDictionary to represent the value, or nil if it is not an `object`
- (NSDictionary *)asObject;

#pragma mark Type Checking

///  Checks whether value is `true`.
///
///  @return `YES` if the value is `true` or `NO` otherwise
- (BOOL)isTrue;

///  Checks whether value is `false`.
///
///  @return `YES` if the value is `false` or `NO` otherwise
- (BOOL)isFalse;

///  Checks whether value is `null`.
///
///  @return `YES` if the value is `null`, `NO` otherwise
- (BOOL)isNull;

///  Checks whether value is a `number`.
///
///  @return `YES` if the value is a `number`, `NO` otherwise
- (BOOL)isNumber;

///  Checks whether value is a `string`
///
///  @return `YES` if the value is a `number`, `NO` otherwise
- (BOOL)isString;

///  Checks whether value is an `array`
///
///  @return `YES` if the value is an `array`, `NO` otherwise
- (BOOL)isArray;

///  Checks whether value is an `object`
///
///  @return `YES` if the value is an `object`, `NO` otherwise
- (BOOL)isObject;

#pragma mark Error Handling

///  Checks whether the JSON has an error associated with it.
///
///  @return `YES` if there is an error, `NO` otherwise
- (BOOL)isError;

///  Returns the error associated with the JSON if one is present
///
///  @return An error or nil
- (NSError *)asError;

#pragma mark Serialization

///  Serializes the value as JSON.
///
///  @return UTF-8 Encoded JSON
- (NSData *)asJSON;

///  Serializes the value as JSON with optional pretty printing.
///
///  @return UTF-8 Encoded JSON, which is pretty printed when NSJSONWritingPrettyPrinted is passed
- (NSData *)asJSONWithOptions:(NSJSONWritingOptions)options;

@end