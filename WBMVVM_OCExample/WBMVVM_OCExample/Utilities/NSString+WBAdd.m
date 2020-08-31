//
//  NSString+WBAdd.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "NSString+WBAdd.h"

@implementation NSString (WBAdd)

+ (BOOL)wb_isEmpty:(NSString *)string {
    if (string == nil || string.length == 0 || [string isKindOfClass:NSNull.class]) {
        return YES;
    }
    return NO;
}

@end
