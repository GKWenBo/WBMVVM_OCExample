//
//  NSKeyedUnarchiver+WBAdd.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "NSKeyedUnarchiver+WBAdd.h"

@implementation NSKeyedUnarchiver (WBAdd)

/**
 Same as unarchiveObjectWithData:, except it returns the exception by reference.
 
 @param data       The data need unarchived.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said pointer is not NULL, point to said NSException.
 */
+ (nullable id)wb_unarchiveObjectWithData:(NSData *)data
                                      cls:(Class)cls
                                exception:(NSException *_Nullable *_Nullable)exception {
    id object = nil;
    @try {
        if (@available(iOS 12.0, *)) {
            object = [NSKeyedUnarchiver unarchivedObjectOfClass:cls fromData:data error:nil];
        } else {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
    }
    @catch (NSException *e)
    {
        if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}

/**
 Same as unarchiveObjectWithFile:, except it returns the exception by reference.
 
 @param path       The path of archived object file.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said  pointer is not NULL, point to said NSException.
 */
+ (nullable id)wb_unarchiveObjectWithFile:(NSString *)path
                                      cls:(Class)cls
                                exception:(NSException *_Nullable *_Nullable)exception {
    id object = nil;
    
    @try {
        if (@available(iOS 12.0, *)) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            object = [NSKeyedUnarchiver unarchivedObjectOfClass:cls fromData:data error:nil];
        } else {
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
    }
    @catch (NSException *e)
    {
        if (exception) *exception = e;
    }
    @finally
    {
    }
    return object;
}

@end
