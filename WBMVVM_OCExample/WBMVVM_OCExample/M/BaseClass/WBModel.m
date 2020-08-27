//
//  WBModel.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBModel.h"

@implementation WBModel

+ (instancetype)modelWithJSON:(id)json {
    return [self yy_modelWithJSON:json];
}

+ (NSArray *)modelArrayWithJSON:(id)json {
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [self yy_modelWithDictionary:dictionary];
}

- (id)toJSONObject {
    return [self yy_modelToJSONObject];
}

- (NSData *)toJSONData {
    return [self yy_modelToJSONData];
}

- (NSString *)toJSONString {
    return [self yy_modelToJSONString];
}

// MARK: - NSCoding, NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self yy_modelInitWithCoder:coder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
