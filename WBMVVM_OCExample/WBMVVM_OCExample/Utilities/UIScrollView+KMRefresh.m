//
//  UIScrollView+KMRefresh.m
//  HBkuaiMi
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo.com. All rights reserved.
//

#import "UIScrollView+KMRefresh.h"

@implementation UIScrollView (KMRefresh)

- (void)addNormalHeaderAndAutoFooterWithHeaderBlock:(void (^)(MJRefreshNormalHeader * _Nonnull))headerBlock
                                        footerBlock:(void (^)(MJRefreshAutoNormalFooter * _Nonnull))footerBlock {
    [self addNormalHeaderWithHeaderBlock:headerBlock];
    [self addAutoFooterWithFooterBlock:footerBlock];
}

- (MJRefreshNormalHeader *)addNormalHeaderWithHeaderBlock:(void (^)(MJRefreshNormalHeader * _Nonnull))headerBlock {
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(&*weakSelf) strongSelf = weakSelf;
        /// 重置没有更多数据
        if (strongSelf.mj_footer) {
            [strongSelf.mj_footer resetNoMoreData];
        }
        if (headerBlock) {
            headerBlock((MJRefreshNormalHeader *)strongSelf.mj_header);
        }
    }];
    
    [header setTitle:@"下拉可以刷新了" forState:MJRefreshStateIdle];
    [header setTitle:@"松开马上刷新了" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    
//    header.stateLabel.textColor = kColorWithHex(0x969696);
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
    return header;
}

- (MJRefreshAutoNormalFooter *)addAutoFooterWithFooterBlock:(void (^)(MJRefreshAutoNormalFooter * _Nonnull))footerBlock {
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong __typeof(&*weakSelf) strongSelf = weakSelf;
        if (footerBlock) {
            footerBlock((MJRefreshAutoNormalFooter *)strongSelf.mj_footer);
        }
    }];
    [footer setTitle:@"松开马上加载更多数据了" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"别拉了，已经到底了..." forState:MJRefreshStateNoMoreData];
    
//    footer.stateLabel.textColor = kColorWithHex(0x969696);
    self.mj_footer = footer;
    return footer;
}

- (void)km_endHeaderRefreshing {
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
}

- (void)km_endFooterRefreshing {
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
}

- (void)km_endRefreshingWithNoMoreData {
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)km_endRefreshing {
    [self km_endHeaderRefreshing];
    [self km_endFooterRefreshing];
}

@end
