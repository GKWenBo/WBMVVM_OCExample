//
//  WBNavigationControllerStack.h
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBViewModelServices;

NS_ASSUME_NONNULL_BEGIN

@interface WBNavigationControllerStack : NSObject

@property (nonatomic, class, nullable) UITabBarController *currentTabbarController;
@property (nonatomic, class, nullable) UINavigationController *currentSelectNavigationController;
@property (nonatomic, class, nullable) UIViewController *currentViewController;
@property (nonatomic, class, nullable) UIViewController *currentNavigationController;
/// Initialization method. This is the preferred way to create a new navigation controller stack.
///
/// services - The service bus of the `Model` layer.
///
/// Returns a new navigation controller stack.
- (instancetype)initWithServices:(id<WBViewModelServices>)services;

///// Pushes the navigation controller.
/////
///// navigationController - the navigation controller
//- (void)pushNavigationController:(UINavigationController *)navigationController;
//
///// Pops the top navigation controller in the stack.
/////
///// Returns the popped navigation controller.
//- (UINavigationController *)popNavigationController;
//
///// Retrieves the top navigation controller in the stack.
/////
///// Returns the top navigation controller in the stack.
//- (UINavigationController *)topNavigationController;

@end

NS_ASSUME_NONNULL_END
