//
//  UINavigationController+Leaks.m
//  INT
//
//  Created by yuehuig on 2021/9/8.
//

#import "UINavigationController+Leaks.h"
#import "YHHook.h"
#import <objc/runtime.h>

@implementation UINavigationController (Leaks)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [YHHook hookClass:self originalSelector:@selector(popViewControllerAnimated:) swizzleSelector:@selector(yh_popViewControllerAnimated:)];
    });
}

- (UIViewController *)yh_popViewControllerAnimated:(BOOL)animated {
    UIViewController *popVc = [self yh_popViewControllerAnimated:animated];
    extern const char * kLeaksDefineKey;
    objc_setAssociatedObject(popVc, kLeaksDefineKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return popVc;
}

@end
