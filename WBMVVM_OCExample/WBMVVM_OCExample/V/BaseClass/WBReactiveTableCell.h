//
//  WBReactiveCell.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBReactiveView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBReactiveTableCell <NSObject, WBReactiveView>

/// Cell 重用ID
@property (class, readonly) NSString *identifier;

@optional
+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView
                                       indexPath:(NSIndexPath *)indexPath;
+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
