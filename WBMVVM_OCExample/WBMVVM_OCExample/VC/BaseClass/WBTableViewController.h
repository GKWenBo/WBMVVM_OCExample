//
//  WBTableViewController.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBViewController.h"
#import "WBTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBTableViewController : WBViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/// The table view for tableView controller.
/// tableView
@property (nonatomic, strong, readonly) UITableView *tableView;

/// `tableView` 的内容缩进，default is UIEdgeInsetsMake(64,0,0,0)，you can override it
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/// reload tableView data , sub class can override
- (void)reloadData;

/// dequeueReusableCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end

NS_ASSUME_NONNULL_END
