//
//  CategoryController.m
//  INT
//
//  Created by yuehuig on 2021/9/7.
//

#import "CategoryController.h"

@interface Category1 : NSObject

@end

@implementation Category1

- (void)callMe {
    NSLog(@"1");
}

@end

@interface Category1 (test)

@end

@implementation Category1 (test)

- (void)callMe {
    NSLog(@"2");
}

@end

@interface CategorySub : Category1

@end

@implementation CategorySub

- (void)callMe {
    NSLog(@"3");
}

@end

@interface CategoryController ()

@end

@implementation CategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    Category1 *c = [Category1 new];
    [c callMe];
    
    CategorySub *subC = [CategorySub new];
    [subC callMe];
    
    [(Category1 *)subC callMe];
}

@end
