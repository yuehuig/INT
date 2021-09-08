//
//  YHHook.m
//  INT
//
//  Created by yuehuig on 2021/9/8.
//

#import "YHHook.h"
#import <objc/runtime.h>

@implementation YHHook

+ (void)hookClass:(Class)cls originalSelector:(SEL)originalSEL swizzleSelector:(SEL)swizzleSEL {
    if (!cls) {
        NSLog(@"cls 为nil");
        return;
    }
    
    Method oriMethod = class_getInstanceMethod(cls, originalSEL);
    Method swizzleMethod = class_getInstanceMethod(cls, swizzleSEL);
    
    if (!oriMethod) {
        // ✅ 在oriMethod为nil时，替换后将swizzledSEL复制一个不做任何事的空实现
        class_addMethod(cls, originalSEL, class_getMethodImplementation(cls, swizzleSEL), method_getTypeEncoding(swizzleMethod));
        method_setImplementation(swizzleMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    
    // ✅ 一般交换方法: 交换自己有的方法 -- 走下面 因为自己有意味添加方法失败
    // ✅ 交换自己没有实现的方法:
    // ✅ 首先第一步:会先尝试给自己添加要交换的方法 :personInstanceMethod (SEL) -> swiMethod(IMP)
    // ✅ 然后再将父类的IMP给swizzle  personInstanceMethod(imp) -> swizzledSEL
    
    BOOL didAddMethod = class_addMethod(cls, originalSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzleSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzleMethod);
    }
}

@end
