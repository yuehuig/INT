//
//  Person.h
//  INT
//
//  Created by yuehuig on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (void)sayHi;

@end

NS_ASSUME_NONNULL_END