//
//  UIScrollView+KMRefresh.h
//  HBkuaiMi
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (KMRefresh)

/// 添加上下拉刷新
/// @param headerBlock 头部刷新回调
/// @param footerBlock 底部刷新回调
- (void)addNormalHeaderAndAutoFooterWithHeaderBlock:(void (^)(MJRefreshNormalHeader *header))headerBlock
                                        footerBlock:(void (^)(MJRefreshAutoNormalFooter *footer))footerBlock;
/// 添加头部刷新
/// @param headerBlock 头部刷新回调
- (MJRefreshNormalHeader *)addNormalHeaderWithHeaderBlock:(void (^)(MJRefreshNormalHeader *header))headerBlock;

/// 添加底部刷新
/// @param footerBlock 底部刷新回调
- (MJRefreshAutoNormalFooter *)addAutoFooterWithFooterBlock:(void (^)(MJRefreshAutoNormalFooter *header))footerBlock;

/// 结束头部刷新
- (void)wb_endHeaderRefreshing;
/// 结束底部刷新
- (void)wb_endFooterRefreshing;
/// 结束头尾部刷新
- (void)wb_endRefreshing;
- (void)wb_endRefreshingWithNoMoreData;

@end

NS_ASSUME_NONNULL_END
