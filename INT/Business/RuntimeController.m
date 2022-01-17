//
//  RuntimeController.m
//  INT
//
//  Created by yuehuig on 2021/8/27.
//

#import "RuntimeController.h"
#import <objc/message.h>

@interface RuntimeController ()

@end

@implementation RuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    ((void(*)(id, SEL, id))objc_msgSend)(slf, swizzledSendEventSelector, event);
//    (void(*)(id, SEL, id))objc_msgSend(self, @selector(test));
    void(*msgSend)(id, SEL, NSString *, NSString *) = (__typeof__(msgSend))objc_msgSend;
    msgSend(self, @selector(test:p2:), @"ppp1", @"ppp2");
}

- (void)test:(NSString *)p1 p2:(NSString *)p2 {
    NSLog(@"这是测试.. %@, %@", p1, p2);
}

@end
