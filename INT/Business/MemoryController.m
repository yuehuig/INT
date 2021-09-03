//
//  MemoryController.m
//  INT
//
//  Created by yuehuig on 2021/9/3.
//

#import "MemoryController.h"
#import "Person.h"

@interface MemoryController ()

@end

@implementation MemoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *hh = @"ww";
    
    id cls = [Person class];
    void *obj = &cls;
    [(__bridge id)obj sayHi];
}

@end
