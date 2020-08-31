//
//  WBConstInline.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/31.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConstant.h"

#ifndef WBConstInline_h
#define WBConstInline_h

/// 适配
static inline CGFloat WBConvertPxToPt(CGFloat px) {
    return ceil(px * [UIScreen mainScreen].bounds.size.width / 414.0f);
}

/// 辅助方法 创建一个文件夹
static inline void WBCreateDirectoryAtPath(NSString *path){
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (!isDir) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
/// 微信重要数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *WBAPPDocDirPath(){
    return [WBDocumentDirectory stringByAppendingPathComponent:@"WBMyApp"];
}
/// 通过NSFileManager来获取指定重要数据的路径
static inline NSString *WBFilePathFromAPPDoc(NSString *filename){
    NSString *docPath = WBAPPDocDirPath();
    WBCreateDirectoryAtPath(docPath);
    return [docPath stringByAppendingPathComponent:filename];
}

/// 微信轻量数据备份的文件夹路径，通过NSFileManager来访问
static inline NSString *WBAPPCacheDirPath(){
    return [WBCachesDirectory stringByAppendingPathComponent:@"WBMyAppCache"];
}
/// 通过NSFileManager来访问 获取指定轻量数据的路径
static inline NSString *WBFilePathFromAPPCache(NSString *filename){
    NSString *cachePath = WBAPPCacheDirPath();
    WBCreateDirectoryAtPath(cachePath);
    return [cachePath stringByAppendingPathComponent:filename];
}

#endif /* WBConstInline_h */
