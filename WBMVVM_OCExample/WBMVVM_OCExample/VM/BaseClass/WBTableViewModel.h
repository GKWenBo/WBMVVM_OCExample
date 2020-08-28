//
//  WBTableViewModel.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBTableViewModel : WBViewModel

/// The data source of table view. 这里不能用NSMutableArray，因为NSMutableArray不支持KVO，不能被RACObserve
@property (nonatomic, readwrite, copy) NSArray *dataSource;

/// tableView‘s style defalut is UITableViewStylePlain , 只适合 UITableView 有效
@property (nonatomic, readwrite, assign) UITableViewStyle style;

/// 是否数据是多段 (It's effect tableView's dataSource 'numberOfSectionsInTableView:') defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;

/// 需要支持下来刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/// 需要支持上拉加载 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
/// 是否在上拉加载后的数据,dataSource.count < pageSize 提示没有更多的数据.default is NO 默认做法是数据不够时，隐藏mj_footer
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;


/// 选中命令 eg:  didSelectRowAtIndexPath:
@property (nonatomic, readwrite, strong) RACCommand *didSelectCommand;
/// 请求服务器数据的命令
@property (nonatomic, readonly, strong) RACCommand *requestRemoteDataCommand;

/** fetch the local data */
- (id)fetchLocalData;

/// 请求错误信息过滤
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

/// 当前页之前的所有数据
- (NSUInteger)offsetForPage:(NSUInteger)page;

/** request remote data or local data, sub class can override it
 *  page - 请求第几页的数据
 */
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

@end

NS_ASSUME_NONNULL_END
