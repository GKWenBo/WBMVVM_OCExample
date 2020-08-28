//
//  WBView.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/27.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBView.h"

@implementation WBView

- (instancetype)initWithViewModel:(id)viewModel {
    return [super initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        [self bindViewModel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self makeUI];
        [self bindViewModel];
    }
    return self;
}

- (void)makeUI {}
- (void)bindViewModel {}
- (void)bindViewModel:(id)viewModel {}

@end
