//
//  WBTableViewController.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBTableViewController.h"
#import "UIScrollView+KMRefresh.h"

@interface WBTableViewController ()

/// tableView
@property (nonatomic, readwrite, strong) UITableView *tableView;
/// contentInset defaul is (64 , 0 , 0 , 0)
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// 视图模型
@property (nonatomic, readonly, strong) WBTableViewModel *viewModel;

@end

@implementation WBTableViewController

@dynamic viewModel;

- (instancetype)initWithViewModel:(WBViewModel *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        @weakify(self);
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            /// 请求第一页的网络数据
            [self.viewModel.requestRemoteDataCommand execute:@(1)];
        }];
    }
    return self;
}

// MARK: - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    /// observe viewModel's dataSource
    @weakify(self)
    [[RACObserve(self.viewModel, dataSource) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self reloadData];
    }];
    
    /// 隐藏emptyView
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        UIView *emptyDataSetView = [self.tableView.subviews.rac_sequence objectPassingTest:^BOOL(__kindof UIView * _Nullable value) {
            return [value isKindOfClass:NSClassFromString(@"DZNEmptyDataSetView")];
        }];
        emptyDataSetView.alpha = 1.0 - executing.floatValue;
    }];
    
    /// 新增一个需求 有些场景下 进来 不需要下拉刷新和上拉加载  但是切换一种模式 又想要下拉刷新和上拉加载了
    [[[[RACObserve(self.viewModel, shouldPullDownToRefresh) distinctUntilChanged] skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.tableView addNormalHeaderWithHeaderBlock:^(MJRefreshNormalHeader * _Nonnull header) {
                @strongify(self);
                [self tableViewDidTriggerHeaderRefresh];
            }];
        } else {
            self.tableView.mj_header = nil;
        }
    }];
    
    [[[[RACObserve(self.viewModel, shouldPullUpToLoadMore) distinctUntilChanged] skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.tableView addAutoFooterWithFooterBlock:^(MJRefreshAutoNormalFooter * _Nonnull header) {
                @strongify(self);
                [self tableViewDidTriggerFooterRefresh];
            }];
            
            /// 隐藏footer or 无更多数据
            RAC(self.tableView.mj_footer, hidden) = [[RACObserve(self.viewModel, dataSource)
                                                      deliverOnMainThread]
                                                     map:^(NSArray *dataSource) {
                                                         @strongify(self)
                                                         NSUInteger count = dataSource.count;
                                                         /// 无数据，默认隐藏mj_footer
                                                         if (count == 0) return @1;
                                                         
                                                         if (self.viewModel.shouldEndRefreshingWithNoMoreData) return @(0);
                                                         
                                                         /// because of
                                                         return (count % self.viewModel.perPage) ? @1 : @0;
                                                     }];
        } else {
            self.tableView.mj_footer = nil;
        }
    }];
}

// MARK: - 上下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand execute:@(1)]
      deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.page = 1;
        
        /// 重置没有更多的状态
        if (self.viewModel.shouldEndRefreshingWithNoMoreData) [self.tableView.mj_footer resetNoMoreData];
    }
     error:^(NSError * _Nullable error) {
        @strongify(self);
        /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以reload = NO即可
        [self.tableView.mj_header endRefreshing];
    }
     completed:^{
        @strongify(self);
        /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以只要结束刷新即可
        [self.tableView.mj_header endRefreshing];
        [self requestDataCompleted];
    }];
}

- (void)tableViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page + 1)]
      deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.page += 1;
    }
     error:^(NSError * _Nullable error) {
        [self.tableView.mj_footer endRefreshing];
    }
     completed:^{
        [self.tableView.mj_footer endRefreshing];
        /// 请求完成
        [self requestDataCompleted];
    }];
}

// MARK: - Private Method
- (void)requestDataCompleted {
    NSUInteger count = self.viewModel.dataSource.count;
    if (self.viewModel.shouldEndRefreshingWithNoMoreData && count % self.viewModel.perPage) [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - sub class can override it
- (UIEdgeInsets)contentInset {
    return UIEdgeInsetsZero;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}

// MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.viewModel.shouldMultiSections) return self.viewModel.dataSource ? self.viewModel.dataSource.count : 0;
    return self.viewModel.dataSource.count == 0 ? 0 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.shouldMultiSections) return [self.viewModel.dataSource[section] count];
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // fetch object
    id object = nil;
    if (self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (!self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.row];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}

// MARK: - UIScrollViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {}

// MARK: - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:self.viewModel.style];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // set delegate and dataSource
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = self.contentInset;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        if (@available(iOS 11.0, *)) {
            /// CoderMikeHe: 适配 iPhone X + iOS 11，
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            /// iOS 11上发生tableView顶部有留白，原因是代码中只实现了heightForHeaderInSection方法，而没有实现viewForHeaderInSection方法。那样写是不规范的，只实现高度，而没有实现view，但代码这样写在iOS 11之前是没有问题的，iOS 11之后应该是由于开启了估算行高机制引起了bug。
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        
        /// 添加加载和刷新控件
        @weakify(self);
        if (self.viewModel.shouldPullDownToRefresh) {
            /// 下拉刷新
            [self.tableView addNormalHeaderWithHeaderBlock:^(MJRefreshNormalHeader * _Nonnull header) {
                @strongify(self);
                [self tableViewDidTriggerHeaderRefresh];
            }];
            /// 开始请求数据
            [self.tableView.mj_header beginRefreshing];
        }
        
        if (self.viewModel.shouldPullUpToLoadMore) {
            /// 上拉加载
            [self.tableView addAutoFooterWithFooterBlock:^(MJRefreshAutoNormalFooter * _Nonnull header) {
                @strongify(self);
                [self tableViewDidTriggerFooterRefresh];
            }];
            
            /// 隐藏footer or 无更多数据
            RAC(self.tableView.mj_footer, hidden) = [[RACObserve(self.viewModel, dataSource) deliverOnMainThread] map:^id _Nullable(NSArray *dataArray) {
                @strongify(self)
                NSUInteger count = dataArray.count;
                /// 无数据，默认隐藏mj_footer
                if (count == 0) return @1;
                
                if (self.viewModel.shouldEndRefreshingWithNoMoreData) return @(0);
                
                /// because of
                return (count % self.viewModel.perPage) ? @1 : @0;
            }];
        }
        
    }
    return _tableView;
}

@end
