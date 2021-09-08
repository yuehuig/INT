//
//  YHHook.h
//  INT
//
//  Created by yuehuig on 2021/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHHook : NSObject

+ (void)hookClass:(Class)cls originalSelector:(SEL)originalSEL swizzleSelector:(SEL)swizzleSEL;

@end

NS_ASSUME_NONNULL_END
