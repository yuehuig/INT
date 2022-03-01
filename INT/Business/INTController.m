//
//  INTERVIEW.m
//  INT
//
//  Created by 郭月辉 on 2022/3/1.
//

#import "INTController.h"
#import "INT-Swift.h"

@interface Sark : NSObject
@end

@implementation Sark
@end

@interface INTController ()
@property (nonatomic, strong) EaseTestView *easeTV;

@end

@implementation INTController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.easeTV = [[EaseTestView alloc] init];
    
    [self.easeTV showToView:self.view target:self preFuncName:@"test" clickAction:^(NSString * _Nullable str) {
        
    }];
}

- (void)test1 {
   
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
    BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];
     
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
    
    NSLog(@"%@", [[NSObject class] superclass]); // 为 null
}

@end
