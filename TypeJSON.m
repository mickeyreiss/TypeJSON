#import "TypeJSON.h"

#import <CoreFoundation/CoreFoundation.h>

NSString *TypeJSONErrorDomain = @"TypeJSONErrorDomain";

typedef NS_ENUM(NSInteger, TypeJSONErrorCode) {
    TypeJSONErrorCodeNotFound = 404,
    TypeJSONErrorCodeNotAcceptable = 406,
};

@interface TypeJSON ()
@property (nonatomic, strong) id value;
@end

@implementation TypeJSON

+ (instancetype)fromData:(NSData *)data {
    return [[self alloc] initWithData:data];
}

+ (instancetype)emptyObject {
    return [[self alloc] initWithValue:@{}];
}

- (instancetype)initWithData:(NSData *)data {
    self = [self init];
    if (self) {
        NSError *error;
        self.value = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
        if (error) {
            self.value = error;
        }
    }
    return self;
}

- (instancetype)initWithValue:(id)value {
    self = [self init];
    if (self) {
        self.value = value;
    }
    return self;
}

- (instancetype)initWithError:(TypeJSONErrorCode)errorCode {
    return [self initWithValue:[NSError errorWithDomain:TypeJSONErrorDomain
                                                   code:errorCode
                                               userInfo:nil]];
}

#pragma mark Collection Accessors

- (TypeJSON *)objectForKeyedSubscript:(NSString *)key {
    if (self.isError) {
        return self;
    } else if ([self.value respondsToSelector:@selector(objectForKeyedSubscript:)]) {
        id newRoot = self.value[key];
        if (newRoot) {
            return [[TypeJSON alloc] initWithValue:newRoot];
        } else {
            return [[TypeJSON alloc] initWithError:TypeJSONErrorCodeNotFound];
        }
    } else {
        return [[TypeJSON alloc] initWithError:TypeJSONErrorCodeNotAcceptable];
    }
}

- (TypeJSON *)objectAtIndexedSubscript:(NSUInteger)index {
    if (self.isError) {
        return self;
    } else if ([self.value respondsToSelector:@selector(objectAtIndexedSubscript:)] && [self.value respondsToSelector:@selector(count)]) {
        if (index < [self.value count]) {
            return [[TypeJSON alloc] initWithValue:self.value[index]];
        } else {
            return [[TypeJSON alloc] initWithError:TypeJSONErrorCodeNotFound];
        }
    } else {
        return [[TypeJSON alloc] initWithError:TypeJSONErrorCodeNotAcceptable];
    }
}


#pragma mark Value Accessors

- (NSString *)asString {
    return self.isString ? self.value : nil;
}

- (NSDecimalNumber *)asNumber {
    return self.isNumber ? [NSDecimalNumber decimalNumberWithDecimal:[self.value decimalValue]] : nil;
}

- (BOOL)asBool {
    return self.isTrue;
}

- (NSNull *)asNull {
    return self.isNull ? self.value : nil;
}

- (NSArray *)asArray {
    return self.isArray ? self.value : nil;
}

- (NSDictionary *)asObject {
    return self.isObject ? self.value : nil;
}

#pragma mark Type Checking

- (BOOL)isTrue {
    return [self.value isEqual:@(YES)];
}

- (BOOL)isFalse {
    return [self.value isEqual:@(NO)];
}

- (BOOL)isNull {
    return [self.value isEqual:NSNull.null];
}

- (BOOL)isNumber {
    return [self.value isKindOfClass:[NSNumber class]] && CFGetTypeID((__bridge CFTypeRef)self.value) != CFBooleanGetTypeID();
}

- (BOOL)isString {
    return [self.value isKindOfClass:[NSString class]];
}

- (BOOL)isArray {
    return [self.value isKindOfClass:[NSArray class]];
}

- (BOOL)isObject {
    return [self.value isKindOfClass:[NSDictionary class]];
}


#pragma mark Error Handling

- (BOOL)isError {
    return [self.value isKindOfClass:[NSError class]];
}

- (NSError *)asError {
    return self.isError ? self.value : nil;
}


#pragma mark Serialization

- (NSData *)asJSON {
    return [self asJSONWithOptions:0];
}

- (NSData *)asJSONWithOptions:(NSJSONWritingOptions)options {
    return [NSJSONSerialization dataWithJSONObject:self.value
                                           options:options
                                             error:nil];
}

@end