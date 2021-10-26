//
//  Person.m
//  INT
//
//  Created by yuehuig on 2021/8/23.
//

#import "Person.h"

@implementation Person

- (void)sayHi {
    NSLog(@"[%@]: %s  %@", [self class], __FUNCTION__, self.name);
}

- (void)setObserveTest:(NSString *)observeTest {
    _observeTest = observeTest;
    NSLog(@"come here => %s", __FUNCTION__);
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
