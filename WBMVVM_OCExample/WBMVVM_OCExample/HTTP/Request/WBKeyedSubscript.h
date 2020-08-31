//
//  WBKeyedSubscript.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBKeyedSubscript : NSObject

+ (instancetype)subscript;
/// 拼接一个字典
+ (instancetype)subscriptWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
/// 转换为字典
- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
