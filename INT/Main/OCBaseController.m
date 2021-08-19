//
//  OCBaseController.m
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

#import "OCBaseController.h"

@interface OCBaseController ()

@end

@implementation OCBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTitle];
}

- (void)setupTitle {
    NSString *className = NSStringFromClass([self class]);
    className = [className stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
    self.title = className;
}

@end
