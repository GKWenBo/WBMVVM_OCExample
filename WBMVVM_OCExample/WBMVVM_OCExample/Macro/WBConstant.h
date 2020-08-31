//
//  WBConstant.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>

// AppCaches 文件夹路径
#define WBCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// App DocumentDirectory 文件夹路径
#define WBDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

NS_ASSUME_NONNULL_BEGIN

typedef void(^WBVoidBlock)(void);
typedef void(^WBVoidBlock_Id)(id object);

@interface WBConstant : NSObject

@end

NS_ASSUME_NONNULL_END
