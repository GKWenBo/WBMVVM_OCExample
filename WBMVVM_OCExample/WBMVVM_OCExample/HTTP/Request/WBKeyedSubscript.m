//
//  WBKeyedSubscript.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBKeyedSubscript.h"

@interface WBKeyedSubscript ()

/// 字典
@property (nonatomic, readwrite, strong) NSMutableDictionary *kvs;

@end

@implementation WBKeyedSubscript

+ (instancetype)subscript {
    return [[self alloc] init];
}

+ (instancetype)subscriptWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.kvs = @{}.mutableCopy;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.kvs = @{}.mutableCopy;
        if (dict.count) {
            [self.kvs addEntriesFromDictionary:dict];
        }
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    return key ? [self.kvs objectForKey:key] : nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        if (obj) {
            [self.kvs setObject:obj forKey:key];
        } else {
            [self.kvs removeObjectForKey:key];
        }
    }
}

- (NSDictionary *)dictionary {
    return self.kvs.copy;
}

@end
