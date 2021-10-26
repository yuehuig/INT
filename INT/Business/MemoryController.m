//
//  MemoryController.m
//  INT
//
//  Created by yuehuig on 2021/9/3.
//

#import "MemoryController.h"
#import "Person.h"

@interface MemoryController ()
@property (nonatomic, strong) NSString *str;
@end

@implementation MemoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *hh = @"ww";
    
    id cls = [Person class];
    void *obj = &cls;
    [(__bridge id)obj sayHi];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test3];
}

- (void)test3 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 10000; i++) {
        dispatch_async(queue, ^{
            self.str = [NSString stringWithFormat:@"abc"];
        });
    }
}

- (void)test2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 10000; i++) {
        dispatch_async(queue, ^{
            self.str = [NSString stringWithFormat:@"abcdefghijk"];
//            self.str = @"abcdefghijk";
        });
    }
}

/**
 输出：24---16---24---24---16---
 
 LGStruct1：
 char a [0]; // [1,7]为空，因为都不是double字节8的倍数
 double b [8,15] // 8位double字节8，直接存放
 int c [16,19] // 16为int字节4 的倍数，直接存放
 short d [20,21] // 20 为short 2 的倍数，直接存放

 LGStruct1一共占有了22字节，但是总大小一定要为元素最大字节数的倍数，里面最大为8字节，所以总字节数应为8的倍数，所以共申请24字节，以此类推，可以得到LGStruct2共占有了16字节
 */
/// 内存对齐
- (void)test1 {
    struct LGStruct1 {
        char a;     // 1 [0]
        double b;   // 8 [8,15]
        int c;      // 4 [16,19]
        short d;    // 2 [20,21]
    } MyStruct1;

    struct LGStruct2 {
        double b;   // 8 [0,7]
        int c;      // 4 [8,11]
        char a;     // 1 [12]
        short d;    // 2 [14,15]
    } MyStruct2;
    
    struct LGStruct3 {
        int c;
        double b;
        char a;
        short d;
    } MyStruct3;
    
    struct LGStruct4 {
        int c;
        short d;
        double b;
        char a;
    } MyStruct4;
    
    struct LGStruct5 {
        int c;
        short d;
        char a;
        double b;
    } MyStruct5;

    NSLog(@"%lu---%lu---%lu---%lu---%lu---",sizeof(MyStruct1),sizeof(MyStruct2),sizeof(MyStruct3),sizeof(MyStruct4),sizeof(MyStruct5));
}

@end
