//
//  BlockController.m
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

#import "BlockController.h"
#import "Person.h"

@interface BlockController ()
@property (nonatomic, copy) void(^blk)(void);

@property (nonatomic, copy) int(^blk1)(int);
@property (nonatomic, strong) Person *p;

@end

@implementation BlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test4];
}

- (void)test6 {
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
    void(^block)(void) = ^{
        NSLog(@"%@", arr);
        [arr addObject:@"4"];
    };
    
    [arr addObject:@"3"];
    
    arr = nil;
    
    block();
}

- (void)test5 {
    Person *p = [[Person alloc]init];
    p.name = @"Hello World";
    
//    __weak typeof(p) weakP = p;
    p.block = ^{
//        __strong typeof(weakP) strongP = weakP;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            NSLog(@"my name is = %@", strongP.name);
            NSLog(@"my name is = %@", p.name);
        });
    };
//    p.block();
//    self.p = p;
}

- (void)test4 {
    Person *p = [[Person alloc]init];
    p.name = @"Hello World";
    
    __weak typeof(p) weakP = p;
    p.block = ^{
        __strong typeof(weakP) strongP = weakP;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"my name is = %@", strongP.name);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSLog(@"2  my name is = %@", strongP.name);
            });
        });
    };
    p.block();
}

// result is 24, block type is <__NSMallocBlock__: 0x600000ac0210>
- (void)test3 {
    __block int multiplier = 10;
    self.blk1 = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 6;
    [self executeBlock];
}

- (void)executeBlock {
    NSLog(@"result is %d, block type is %@", self.blk1(4), self.blk1);
}

// result is 8, block type is <__NSMallocBlock__: 0x600000ac0210>
- (void)test2 {
    __block int multiplier = 6;
    int(^Block)(int) = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"result is %d, block type is %@", Block(2), Block);
}


#pragma mark - block 的类型   捕获变量后 又是什么类型

void(^block3)(void) = ^{
    NSLog(@"i am block3");
};

NSInteger mm = 3;
void(^block6)(void) = ^{
    NSLog(@"i am block6 -- %zd", mm);
};


- (void)test1 {
    void(^block)(void) = ^{
        NSLog(@"test");
    };
    
    NSLog(@"✅【block】为：%@", [block class]);  // __NSGlobalBlock__
    
    // ---------------------
    NSInteger a = 1;
    void(^block1)(void) = ^{
        NSLog(@"%zd", a);
    };
    
    NSLog(@"✅【block1】为：%@", [block1 class]);  // ARC下自动copy 为 __NSMallocBlock__  MRC下为  __NSStackBlock__
    
    // ---------------------
    Person *p = [Person new];
    void(^block2)(void) = ^{
        NSLog(@"%@", p);
    };
    
    NSLog(@"✅【block2】为：%@", [block2 class]);  // ARC下自动copy 为 __NSMallocBlock__  MRC下为  __NSStackBlock__
    
    // ---------------------
    NSLog(@"✅【block3】为：%@", [block3 class]);  // __NSGlobalBlock__
    
    
    // ---------------------
    void(^block4)(void) = ^{
        NSLog(@"%@", p);
    };
    
    self.blk = block4;
    NSLog(@"✅【block4】为：%@", [block4 class]);   // ARC下自动copy 为 __NSMallocBlock__  MRC下为  __NSStackBlock__
    NSLog(@"✅【self.blk】为：%@", [self.blk class]); // __NSMallocBlock__
    
    // ---------------------
    void(^block5)(void) = ^{
        NSLog(@"test");
    };
    self.blk = block5;
    NSLog(@"✅【block5】为：%@", [block5 class]);   // __NSGlobalBlock__
    NSLog(@"✅【self.blk】为：%@", [self.blk class]); // __NSGlobalBlock__
    
    //----------------
    NSLog(@"✅【block6】为：%@", [block6 class]);   // __NSGlobalBlock__
    
    // ---------------------
    static NSInteger nn = 66;
    void(^block7)(void) = ^{
        NSLog(@"%zd", nn);
    };
    
    NSLog(@"✅【block7】为：%@", [block7 class]);   //   __NSGlobalBlock__

}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
