//
//  WBReactiveCollectionCell.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBReactiveView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBReactiveCollectionCell <NSObject, WBReactiveView>

/// Cell 重用ID
@property (class, readonly) NSString *identifier;
+ (instancetype)dequeueReusableCellWithTableView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
