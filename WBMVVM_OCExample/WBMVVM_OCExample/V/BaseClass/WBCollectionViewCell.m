//
//  WBCollectionViewCell.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBCollectionViewCell.h"

@implementation WBCollectionViewCell

+ (NSString *)identifier {
    return [NSString stringWithCString:object_getClassName([self class]) encoding:NSUTF8StringEncoding];
}

+ (instancetype)dequeueReusableCellWithTableView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
