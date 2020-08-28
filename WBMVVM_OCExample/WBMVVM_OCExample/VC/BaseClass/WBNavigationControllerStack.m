//
//  WBNavigationControllerStack.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBNavigationControllerStack.h"
#import "WBRouter.h"
#import <ReactiveObjC.h>
#import "WBViewModelServices.h"
#import "WBNavigationController.h"

@interface WBNavigationControllerStack ()

@property (nonatomic, strong) id<WBViewModelServices> services;
//@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation WBNavigationControllerStack

- (instancetype)initWithServices:(id<WBViewModelServices>)services {
    self = [super init];
    if (self) {
        self.services = services;
        
        [self registerNavigationHooks];
    }
    return self;
}

-  (void)registerNavigationHooks {
    @weakify(self);
    /// push
    [[(NSObject *)self.services rac_signalForSelector:@selector(pushViewModel:animated:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        
        UIViewController *vc = [[WBRouter shareRouter] viewControllerForViewModel:x.first];
        [[self class].currentSelectNavigationController pushViewController:vc animated:[x.second boolValue]];
    }];
    
    /// pop
    [[(NSObject *)self.services rac_signalForSelector:@selector(popViewModelAnimated:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [[self class].currentViewController.navigationController popViewControllerAnimated:[x.first boolValue]];
    }];
    
    /// popToRoot
    [[(NSObject *)self.services rac_signalForSelector:@selector(popToRootViewModelAnimated:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [[self class].currentViewController.navigationController popToRootViewControllerAnimated:[x.first boolValue]];
    }];
    
    /// present
    [[(NSObject *)self.services rac_signalForSelector:@selector(presentViewModel:animated:completion:)] subscribeNext:^(RACTuple * _Nullable x) {
         @strongify(self);
        UIViewController *vc = [[WBRouter shareRouter] viewControllerForViewModel:x.first];
        if (![vc isKindOfClass:[UINavigationController class]]) {
            vc = [[WBNavigationController alloc]initWithRootViewController:vc];
        }
        
        // 适配 iOS 13.0+ : - [iOS13开发中可能会出现的present viewcontroller相关问题](https://www.jianshu.com/p/4f96d078f1f3)
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[self class].currentSelectNavigationController presentViewController:vc animated:[x.second boolValue] completion:x.third];
    }];
    
    /// dismiss
    [[(NSObject *)self.services rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)] subscribeNext:^(RACTuple * _Nullable x) {
         @strongify(self);
        [[self class].currentViewController.navigationController dismissViewControllerAnimated:[x.first boolValue] completion:x.second];
    }];
    
    /// root vc
    [[(NSObject *)self.services rac_signalForSelector:@selector(resetRootViewModel:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        UIViewController *vc = [[WBRouter shareRouter] viewControllerForViewModel:x.first];
        UIApplication.sharedApplication.keyWindow.rootViewController = vc;
    }];
}

// MARK: - getter
+ (UITabBarController *)currentTabbarController {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    if (!window) {
        for (UIWindow *subWindow in UIApplication.sharedApplication.windows) {
            if (subWindow.isKeyWindow) {
                window = window;
                break;
            }
        }
    }
    
    UIViewController *vc = window.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)vc;
    }
    return nil;
}

+ (UINavigationController *)currentSelectNavigationController {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    if (!window) {
        for (UIWindow *subWindow in UIApplication.sharedApplication.windows) {
            if (subWindow.isKeyWindow) {
                window = window;
                break;
            }
        }
    }
    
    UIViewController *rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabarController = self.currentTabbarController;
        UINavigationController *selectedNV = (UINavigationController *)tabarController.selectedViewController;
        if ([selectedNV isKindOfClass:[UINavigationController class]]) {
            return selectedNV;
        }
    }
    return nil;
}

+ (UIViewController *)currentViewController {
    UINavigationController *selectedNV = self.currentSelectNavigationController;
    if (selectedNV.viewControllers.count > 0) {
        return [selectedNV.viewControllers lastObject];
    }
    return nil;
}

+ (UIViewController *)currentNavigationController {
    return self.currentViewController.navigationController;
}

@end
