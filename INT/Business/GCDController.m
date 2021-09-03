//
//  GCDController.m
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

#import "GCDController.h"
#import "Person.h"

@interface GCDController ()
@property (nonatomic, copy) NSString *tempStr;
@property (nonatomic, strong) NSMutableArray *mArr;
@property (nonatomic, assign) NSInteger m;
@end

@implementation GCDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mArr = [NSMutableArray array];
    self.m = 1000;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test4];
}

/**
 第一段代码会崩溃 多线程 release retain
 
 第二段代码不会崩溃  TagPointer
 
 第三段代码不会崩溃  常量字符串
 
 第四段代码可能会崩溃  malloc: *** error for object 0x7fb154073000: pointer being freed was not allocated
 `-[__NSArrayM insertObject:atIndex:]:
 @"*** %s: index %lu beyond bounds [0 .. %lu]"
 malloc: double free for ptr 0x7f857503d600
 
 1 多线程问题  加锁
 2 内存问题  加autoreleasepoll
 */
- (void)test4 {
    //第1段代码
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(queue, ^{
//            self.tempStr = [NSString stringWithFormat:@"asdasdefafdfa"];
//        });
//    }
//    NSLog(@"end");

    
    //第2段代码
//   dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//   for (int i = 0; i < 1000; i++) {
//       dispatch_async(queue, ^{
//           self.tempStr = [NSString stringWithFormat:@"abc"];
//       });
//   }
//   NSLog(@"end");
    
    //第3段代码
//   dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//   for (int i = 0; i < 1000; i++) {
//       dispatch_async(queue, ^{
//           self.tempStr = @"asdasdefafdfa";
//       });
//   }
//   NSLog(@"end");
    
    //第4段代码
   dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
   for (int i = 0; i < 10000; i++) {
       dispatch_async(queue, ^{
//           @synchronized (self) {
           @autoreleasepool {
               [self.mArr addObject:[Person new]];
               NSLog(@"%zd", self.mArr.count);
           }
               
//           }
       });
   }
   NSLog(@"end");
    
    //第5段代码
//   dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//   for (int i = 0; i < 1000; i++) {
//       dispatch_async(queue, ^{
//           self.m -= 1;
//           NSLog(@"%zd", self.m);
//       });
//   }

}

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)test3 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncConcurrent---end");
}



#pragma mark 栅栏函数
/**
 
 INT[23001:1199860] dispatch_barrier --- begin
 INT[23001:1199860] dispatch_barrier --- end
 INT[23001:1200710] 追加任务1
 INT[23001:1200418] 追加任务2
 INT[23001:1200710] 1---<NSThread: 0x600003a08480>{number = 7, name = (null)}
 INT[23001:1200418] 2---<NSThread: 0x600003af97c0>{number = 2, name = (null)}
 INT[23001:1200710] 1---<NSThread: 0x600003a08480>{number = 7, name = (null)}
 INT[23001:1200418] 2---<NSThread: 0x600003af97c0>{number = 2, name = (null)}
 INT[23001:1200418] 追加栅栏函数任务
 INT[23001:1200418] barrier---<NSThread: 0x600003af97c0>{number = 2, name = (null)}
 INT[23001:1200418] barrier---<NSThread: 0x600003af97c0>{number = 2, name = (null)}
 INT[23001:1200710] 追加任务4
 INT[23001:1200418] 追加任务3
 INT[23001:1200418] 3---<NSThread: 0x600003af97c0>{number = 2, name = (null)}
 INT[23001:1200710] 4---<NSThread: 0x600003a08480>{number = 7, name = (null)}
 INT[23001:1200418] 3---<NSThread: 0x600003af97c0>{number = 2, name = (null)}
 INT[23001:1200710] 4---<NSThread: 0x600003a08480>{number = 7, name = (null)}
 
 */

- (void)test2 {
    NSLog(@"dispatch_barrier --- begin");
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //追加任务1
        NSLog(@"追加任务1");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务2
        NSLog(@"追加任务2");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_barrier_async(queue, ^{
        //追加栅栏函数任务
        NSLog(@"追加栅栏函数任务");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"barrier---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务3
        NSLog(@"追加任务3");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //追加任务4
        NSLog(@"追加任务4");
        for (int i = 0; i < 2; ++i) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            //打印当前线程
            NSLog(@"4---%@",[NSThread currentThread]);
        }
    });
    //不需要等待，直接执行
    NSLog(@"dispatch_barrier --- end");
}

- (void)test1 {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
        
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
    
    dispatch_barrier_sync(concurrentQueue, ^{
        NSLog(@"barrier");
    });
    
    for (NSInteger i = 10; i < 20; i++) {
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"%zd",i);
        });
    }
}

@end
