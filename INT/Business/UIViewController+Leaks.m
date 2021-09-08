//
//  UIViewController+Leaks.m
//  INT
//
//  Created by yuehuig on 2021/9/8.
//

#import "UIViewController+Leaks.h"
#import "YHHook.h"
#import <objc/runtime.h>

// 不能用static修饰 不然extern 访问不到
const void * const kLeaksDefineKey = &kLeaksDefineKey;

@implementation UIViewController (Leaks)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [YHHook hookClass:self originalSelector:@selector(viewWillAppear:) swizzleSelector:@selector(yh_viewWillAppear:)];
        [YHHook hookClass:self originalSelector:@selector(viewDidDisappear:) swizzleSelector:@selector(yh_viewDidDisappear:)];
    });
}

- (void)yh_viewWillAppear:(BOOL)animated {
//    NSLog(@"🐶 hook ->: %s", __FUNCTION__);
    [self yh_viewWillAppear:animated];
    objc_setAssociatedObject(self, kLeaksDefineKey, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yh_viewDidDisappear:(BOOL)animated {
//    NSLog(@"🐶 hook ->: %s", __func__);
    [self yh_viewDidDisappear:animated];
    
    if ([objc_getAssociatedObject(self, kLeaksDefineKey) boolValue]) {
        [self checkDealloc];
    }
}

- (void)checkDealloc {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSLog(@"⚠️⚠️⚠️: %@ 未释放", strongSelf);
        }
    });
}

@end
