//
//  LeaksController.m
//  INT
//
//  Created by yuehuig on 2021/9/8.
//

#import "LeaksController.h"

@interface LeaksController ()
@property (nonatomic, copy) void(^block)(void);

@end

@implementation LeaksController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.block = ^{
        NSLog(@"%@", self);
    };
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
