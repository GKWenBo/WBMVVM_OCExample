//
//  WBModel.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBModel : NSObject <YYModel, NSCoding, NSSecureCoding, NSCopying>

// MARK: - YYModel API
/// 将 Json (NSData，NSString，NSDictionary) 转换为 Model
+ (instancetype)modelWithJSON:(id)json;
/// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
/// json-array 转换为 模型数组
+ (NSArray *)modelArrayWithJSON:(id)json;

/// 将 Model 转换为 JSON 对象
- (id)toJSONObject;
/// 将 Model 转换为 NSData
- (NSData *)toJSONData;
/// 将 Model 转换为 JSONString
- (NSString *)toJSONString;

@end

NS_ASSUME_NONNULL_END
