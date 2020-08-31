//
//  NSKeyedUnarchiver+WBAdd.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSKeyedUnarchiver (WBAdd)

/**
 Same as unarchiveObjectWithData:, except it returns the exception by reference.
 
 @param data       The data need unarchived.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said pointer is not NULL, point to said NSException.
 */
+ (nullable id)wb_unarchiveObjectWithData:(NSData *)data
                                      cls:(Class)cls
                                exception:(NSException *_Nullable *_Nullable)exception;

/**
 Same as unarchiveObjectWithFile:, except it returns the exception by reference.
 
 @param path       The path of archived object file.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said  pointer is not NULL, point to said NSException.
 */
+ (nullable id)wb_unarchiveObjectWithFile:(NSString *)path
                                      cls:(Class)cls
                                exception:(NSException *_Nullable *_Nullable)exception;

@end

NS_ASSUME_NONNULL_END
