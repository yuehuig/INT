//
//  GCDController.m
//  INT
//
//  Created by yuehuig on 2021/8/19.
//

#import "GCDController.h"
#import "Person.h"
#import "INT-Swift.h"

@interface GCDController ()
@property (atomic, copy) NSString *tempStr;
//@property (nonatomic, copy) NSString *tempStr;
@property (nonatomic, strong) NSMutableArray *mArr;
// atomic 只保证set方法是安全的 并不能保证多线程设置值
@property (nonatomic, assign) NSInteger m;
@property (nonatomic, strong) EaseTestView *easeTV;

@end

@implementation GCDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mArr = [NSMutableArray array];
    self.m = 1000;
    self.easeTV = [[EaseTestView alloc] init];
    
    [self.easeTV showToView:self.view target:self preFuncName:@"test" clickAction:^(NSString * _Nullable str) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test5];
}

- (void)test8 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"1");
    [self performSelector:@selector(log) withObject:nil afterDelay:0];
    dispatch_after(0, dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
//    [self performSelector:@selector(log) withObject:nil afterDelay:0];
    dispatch_async(queue, ^{
        NSLog(@"3");
//        [self performSelector:@selector(log) withObject:nil afterDelay:0];
//        dispatch_after(0, dispatch_get_main_queue(), ^{
//            NSLog(@"2");
//        });
    });
    NSLog(@"4");
}

- (void)log {
    NSLog(@"log...");
}

/**
 我们分析这段代码，在开始while之后加入一个异步任务，再之后呢，这个是不确定了，可能是执行a++也可能是因不满足退出条件再次执行加入异步任务，直到满足a<2才会退出while循环。那输出结果也就是不确定了，因为可能在判断跳出循环和输出结果的时候另外的线程又执行了一次a++。
 
 ⚠️⚠️⚠️
 如果将那个并发队列改成主队列，执行逻辑还是一样的吗？

 首先主队列是不会开启新线程的，主队列上的异步操作执行时机是等别的任务都执行完了，再来执行添加的a++。显然在while循环里，主队列既有任务还未执行完毕，所以就不会执行a++，也就导致while循环不会退出，形成死循环。
 */
- (void)test7 {
    __block int a = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_queue_t queue = dispatch_get_main_queue();
    while (a < 2) {
        dispatch_async(queue, ^{
            a++;
        });
    }
    NSLog(@"a = %d", a);
}

- (void)test6 {

    /// 创建一个调度组
    dispatch_group_t group = dispatch_group_create();

    dispatch_queue_t theGlobalQueue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t theSerialQueue = dispatch_queue_create("com.junes.serial.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t theConcurrentQueue = dispatch_queue_create("com.junes.serial.queue", DISPATCH_QUEUE_CONCURRENT);

    /// 将任务丢进调度组
    dispatch_group_async(group, theGlobalQueue, ^{
        NSLog(@"任务1 开始 +++++++");

        /// 模拟耗时操作
        sleep(2);

        NSLog(@"任务1 完成 -----------------");
    });

    dispatch_group_async(group, theSerialQueue, ^{
        NSLog(@"任务2 开始 +++++++");

        /// 模拟耗时操作
        sleep(4);

        NSLog(@"任务2 完成 -----------------");
    });

    dispatch_group_enter(group);
    /// 模拟异步网络请求
    dispatch_async(theConcurrentQueue, ^{
        NSLog(@"任务3 开始 +++++++");

        sleep(5);

        NSLog(@"任务3 完成 -----------------");
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有任务都完成了。。。");
    });

    NSLog(@"dispatch_group_notify 为异步执行，并不会阻塞线程。我就是证据");
}

- (void)test5 {
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

/**
 第一段代码会崩溃 多线程 release retain   可采用加锁 或者使用atomic
 
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
//   dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//   for (int i = 0; i < 10000; i++) {
//       dispatch_async(queue, ^{
////           @synchronized (self) {
//           @autoreleasepool {
//               [self.mArr addObject:[Person new]];
//               NSLog(@"%zd", self.mArr.count);
//           }
//
////           }
//       });
//   }
//   NSLog(@"end");
    
    //第5段代码
    self.m = 1000;
   dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
   for (int i = 0; i < 1000; i++) {
       dispatch_async(queue, ^{
//           @synchronized (self) {
               self.m -= 1;
//           }
           NSLog(@"%zd", self.m);
       });
   }

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
