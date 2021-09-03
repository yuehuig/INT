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

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
