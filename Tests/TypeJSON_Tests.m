//
//  JSONWithSubscriptsAndTypesTests.m
//  JSONWithSubscriptsAndTypesTests
//
//  Created by Mickey Reiss on 11/22/14.
//  Copyright (c) 2014 Mickey Reiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TypeJSON.h"

NSData * dataForFixture(NSString *name);

@interface TypeJSON_Tests : XCTestCase
@property (nonatomic, strong) TypeJSON *mickeyMouseProfileJSON;
@property (nonatomic, strong) TypeJSON *invalidJSON;
@property (nonatomic, strong) TypeJSON *arrayJSON;
@property (nonatomic, strong) TypeJSON *stringJSON;
@property (nonatomic, strong) TypeJSON *numberJSON;
@property (nonatomic, strong) TypeJSON *trueJSON;
@property (nonatomic, strong) TypeJSON *falseJSON;
@property (nonatomic, strong) TypeJSON *nullJSON;
@end

@implementation TypeJSON_Tests

- (void)setUp {
    [super setUp];

    self.mickeyMouseProfileJSON = [TypeJSON fromData:dataForFixture(@"mickeyMouseProfile")];
    self.invalidJSON = [TypeJSON fromData:dataForFixture(@"invalidJSON")];
    self.arrayJSON = [TypeJSON fromData:dataForFixture(@"arrayJSONFragment")];
    self.stringJSON = [TypeJSON fromData:dataForFixture(@"stringJSONFragment")];
    self.numberJSON = [TypeJSON fromData:dataForFixture(@"numberJSONFragment")];
    self.trueJSON = [TypeJSON fromData:dataForFixture(@"trueJSONFragment")];
    self.falseJSON = [TypeJSON fromData:dataForFixture(@"falseJSONFragment")];
    self.nullJSON = [TypeJSON fromData:dataForFixture(@"nullJSONFragment")];
}

#pragma mark Initialization

- (void)testErrorForInvalidJSON_returnsCocoaJsonParsingError {
    XCTAssertTrue(self.invalidJSON.isError);
    NSError *error = self.invalidJSON.asError;
    XCTAssertEqual(error.domain, NSCocoaErrorDomain);
    XCTAssertEqual(error.code, NSPropertyListReadCorruptError);
}

- (void)testInitializingFromJSON_object {
    XCTAssertTrue(self.mickeyMouseProfileJSON.isObject);
}

- (void)testInitializingFromJSON_string {
    XCTAssertTrue(self.stringJSON.isString);
    XCTAssertEqualObjects(self.stringJSON.asString, @"hello, world!");
}

- (void)testInitializingFromJSON_array {
    XCTAssertTrue(self.arrayJSON.isArray);
    XCTAssertEqualObjects(self.arrayJSON.asArray, (@[@(1),@"word",NSNull.null]));
}

- (void)testInitializingFromJSON_number {
    XCTAssertTrue(self.numberJSON.isNumber);
    XCTAssertEqual(self.numberJSON.asNumber.integerValue, 42);
}

- (void)testInitializingFromJSON_true {
    XCTAssertTrue(self.trueJSON.isTrue);
}

- (void)testInitializingFromJSON_false {
    XCTAssertTrue(self.falseJSON.isFalse);
}

- (void)testInitializingFromJSON_null {
    XCTAssertTrue(self.nullJSON.isNull);
}

- (void)testInitializingFromJSON_empty {
    TypeJSON *empty = [TypeJSON fromData:[NSData data]];
    XCTAssertTrue(empty.isError);
    NSError *error = empty.asError;
    XCTAssertEqualObjects(error.domain, NSCocoaErrorDomain);
    XCTAssertEqual(error.code, NSPropertyListReadCorruptError);
}

- (void)testEmptyObjectIsEmpty {
    TypeJSON *emptyObject = [TypeJSON emptyObject];

    XCTAssertTrue(emptyObject.isObject);
    XCTAssertEqualObjects(emptyObject.asObject, @{});
}

#pragma mark Accessor Tests

- (void)testStringAccessor {
    XCTAssertEqualObjects(self.mickeyMouseProfileJSON[@"name"].asString, @"Mickey Mouse");
    XCTAssertNil(self.mickeyMouseProfileJSON[@"animated"].asString);
}

- (void)testStringTypeChecker {
    XCTAssertTrue(self.mickeyMouseProfileJSON[@"name"].isString);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"name"].isNumber);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"name"].isObject);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"name"].isArray);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"name"].isFalse);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"name"].isTrue);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"name"].isNull);
}

- (void)testNumberAccessor {
    XCTAssertEqual(self.mickeyMouseProfileJSON[@"details"][@"age"].asNumber.integerValue, 102);
}

- (void)testNumberTypeChecker {
    XCTAssertTrue(self.mickeyMouseProfileJSON[@"details"][@"age"].isNumber);

    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"][@"age"].isString);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"][@"age"].isObject);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"][@"age"].isArray);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"][@"age"].isFalse);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"][@"age"].isTrue);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"][@"age"].isNull);
}

- (void)testTrueAccessor {
    XCTAssertEqual(self.mickeyMouseProfileJSON[@"animated"].asBool, YES);
}

- (void)testTrueTypeChecker {
    XCTAssertTrue(self.mickeyMouseProfileJSON[@"animated"].isTrue);

    XCTAssertFalse(self.mickeyMouseProfileJSON[@"animated"].isString);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"animated"].isNumber);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"animated"].isObject);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"animated"].isArray);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"animated"].isFalse);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"animated"].isNull);
}

- (void)testFalseAccessor {
    XCTAssertEqual(self.mickeyMouseProfileJSON[@"feline"].asBool, NO);
}

- (void)testFalseTypeChecker {
    XCTAssertTrue(self.mickeyMouseProfileJSON[@"feline"].isFalse);

    XCTAssertFalse(self.mickeyMouseProfileJSON[@"feline"].isTrue);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"feline"].isString);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"feline"].isNumber);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"feline"].isObject);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"feline"].isArray);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"feline"].isNull);
}

- (void)testNullAccessor {
    XCTAssertEqualObjects(self.mickeyMouseProfileJSON[@"weakness"].asNull, NSNull.null);
}

- (void)testNullTypeChecker {
    XCTAssertTrue(self.mickeyMouseProfileJSON[@"weakness"].isNull);

    XCTAssertFalse(self.mickeyMouseProfileJSON[@"weakness"].isTrue);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"weakness"].isFalse);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"weakness"].isString);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"weakness"].isNumber);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"weakness"].isObject);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"weakness"].isArray);
}

- (void)testObjectAccessor {
    XCTAssertEqualObjects(self.mickeyMouseProfileJSON[@"details"].asObject, (@{ @"age": @(102), @"species": @"mouse", }));
}

- (void)testObjectTypeChecker {
    XCTAssertTrue(self.mickeyMouseProfileJSON[@"details"].isObject);

    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"].isString);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"].isNumber);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"].isArray);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"].isFalse);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"].isTrue);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"details"].isNull);
}

- (void)testArrayAccessor {
    XCTAssertEqualObjects(self.mickeyMouseProfileJSON[@"friends"].asArray, (@[ @"Minnie", @"Goofy", @"Donald", ]));
}

- (void)testArrayTypeChecker {
    XCTAssertTrue(self.mickeyMouseProfileJSON[@"friends"].isArray);

    XCTAssertFalse(self.mickeyMouseProfileJSON[@"friends"].isString);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"friends"].isNumber);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"friends"].isObject);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"friends"].isFalse);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"friends"].isTrue);
    XCTAssertFalse(self.mickeyMouseProfileJSON[@"friends"].isNull);
}

- (void)testAccessorsForInvalidTypes {
    XCTAssertNil(self.mickeyMouseProfileJSON[@"details"][@"age"].asString);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"name"].asNumber);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"name"].asNull);
    XCTAssertEqual(self.mickeyMouseProfileJSON[@"name"].asBool, NO);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"name"].asObject);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"name"].asArray);
}

- (void)testAccessorsForInvalidKeys {
    XCTAssertNil(self.mickeyMouseProfileJSON[@"not_a_key"].asString);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"not_a_key"].asNumber);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"not_a_key"].asNull);
    XCTAssertEqual(self.mickeyMouseProfileJSON[@"not_a_key"].asBool, NO);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"not_a_key"].asObject);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"not_a_key"].asArray);
}

- (void)testDeeplyNestedInvalidSubscripting {
    XCTAssertNil(self.mickeyMouseProfileJSON[@"not"][@"a"][@"key"].asString);
    XCTAssertNil(self.mickeyMouseProfileJSON[0][1][2].asString);
    XCTAssertNil(self.mickeyMouseProfileJSON[@"not"][1][@"key"][2].asString);
}

- (void)testErrorForInvalidObjectAccess_invalidKeysForObject {
    TypeJSON *invalidKeyJSON = self.mickeyMouseProfileJSON[@"not_a_key"];
    XCTAssertTrue(invalidKeyJSON.isError);
    NSError *error = invalidKeyJSON.asError;
    XCTAssertEqualObjects(error.domain, TypeJSONErrorDomain);
    XCTAssertEqual(error.code, 404);
}

- (void)testErrorForInvalidObjectAccess_invalidIndiciesForArray {
    TypeJSON *invalidIndexJSON = self.mickeyMouseProfileJSON[@"friends"][999];
    XCTAssertTrue(invalidIndexJSON.isError);
    NSError *error = invalidIndexJSON.asError;
    XCTAssertEqualObjects(error.domain, TypeJSONErrorDomain);
    XCTAssertEqual(error.code, 404);
}

- (void)testErrorForInvalidObjectAccess_nestedInvalidKeyAccess {
    TypeJSON *invalidKeyJSON = self.mickeyMouseProfileJSON[@"not_a_key"][999][@"some_other_key"];
    XCTAssertTrue(invalidKeyJSON.isError);
    NSError *error = invalidKeyJSON.asError;
    XCTAssertEqualObjects(error.domain, TypeJSONErrorDomain);
    XCTAssertEqual(error.code, 404);
}

- (void)testErrorForInvalidObjectAccess_nestedInvalidIndexAccess {
    TypeJSON *invalidIndexJSON = self.mickeyMouseProfileJSON[@"friends"][999][@"not_a_key"][888];
    XCTAssertTrue(invalidIndexJSON.isError);
    NSError *error = invalidIndexJSON.asError;
    XCTAssertEqualObjects(error.domain, TypeJSONErrorDomain);
    XCTAssertEqual(error.code, 404);
}

- (void)testErrorForInvalidObjectAccess_notAnObject {
    TypeJSON *notAnObjectJSON = self.mickeyMouseProfileJSON[@"animated"][@"friends"];
    XCTAssertTrue(notAnObjectJSON.isError);
    NSError *error = notAnObjectJSON.asError;
    XCTAssertEqualObjects(error.domain, TypeJSONErrorDomain);
    XCTAssertEqual(error.code, 406);
}

- (void)testErrorForInvalidArrayAccess_notAnArray {
    TypeJSON *notAnObjectJSON = self.mickeyMouseProfileJSON[999];
    XCTAssertTrue(notAnObjectJSON.isError);
    NSError *error = notAnObjectJSON.asError;
    XCTAssertEqualObjects(error.domain, TypeJSONErrorDomain);
    XCTAssertEqual(error.code, 406);
}

#pragma mark Serialization

- (void)testSerializationOfComplexJSON {
    id jsonParsedMickeyMouseProfileAsJSON = [NSJSONSerialization JSONObjectWithData:self.mickeyMouseProfileJSON.asJSON options:0 error:NULL];
    id jsonParsedFixtureData = [NSJSONSerialization JSONObjectWithData:dataForFixture(@"mickeyMouseProfile") options:0 error:NULL];
    XCTAssertEqualObjects(jsonParsedMickeyMouseProfileAsJSON, jsonParsedFixtureData);
}

- (void)testSerializationOfComplexJSON_prettyPrinted {
    id jsonParsedMickeyMouseProfileAsJSON = [NSJSONSerialization JSONObjectWithData:[self.mickeyMouseProfileJSON asJSONWithOptions:NSJSONWritingPrettyPrinted] options:0 error:NULL];
    id jsonParsedFixtureData = [NSJSONSerialization JSONObjectWithData:dataForFixture(@"mickeyMouseProfile") options:0 error:NULL];
    XCTAssertEqualObjects(jsonParsedMickeyMouseProfileAsJSON, jsonParsedFixtureData);
}

@end

NSData * dataForFixture(NSString *name) {
    NSDictionary *fixtures = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:[TypeJSON_Tests class]] pathForResource:@"Fixtures"
                                                                                                ofType:@"plist"]];
    return fixtures[name];
}
