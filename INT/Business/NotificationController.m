//
//  NotificationController.m
//  INT
//
//  Created by yuehuig on 2021/11/2.
//

#import "NotificationController.h"

@interface NotificationController ()

@end

@implementation NotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"TestNotification" object:@1];
}

/// 存储是以name和object为维度的
/// 此处是接收不到通知的
- (void)handleNotification:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [NSNotificationCenter.defaultCenter postNotificationName:@"TestNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
