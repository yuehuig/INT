//
//  AssociatedController.m
//  INT
//
//  Created by yuehuig on 2021/9/3.
//

#import "AssociatedController.h"
#import <objc/runtime.h>
#import "Person.h"

@interface AssociatedController ()

@end

@implementation AssociatedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test1];
}

- (void)test1 {
    
    {
        Person *p = [[Person alloc] init];
        p.name = @"xm";
        NSLog(@"%@", p);
//        objc_setAssociatedObject(self, @"temp", p, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // 用OBJC_ASSOCIATION_ASSIGN 会崩溃   OBJC_ASSOCIATION_RETAIN_NONATOMIC 不会
        objc_setAssociatedObject(self, @"temp", p, OBJC_ASSOCIATION_ASSIGN);
    }
    
    // 用OBJC_ASSOCIATION_ASSIGN 会崩溃 EXC_BAD_ACCESS
    Person *p1 = objc_getAssociatedObject(self, @"temp");
    NSLog(@"%@, %@", p1, p1.name);
}

@end
