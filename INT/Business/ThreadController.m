//
//  ThreadController.m
//  INT
//
//  Created by yuehuig on 2021/8/25.
//

#import "ThreadController.h"
#import "YHThread.h"
#import "Person.h"

@interface ThreadController ()
@property (nonatomic, strong) YHThread *thread;

@property (nonatomic, strong) NSLock *lock1;
@property (nonatomic, strong) NSLock *lock2;

@end

@implementation ThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 1. 初始化线程对象
     _thread = [[YHThread alloc] initWithTarget:self selector:@selector(runThread:) object:@"子线程执行任务"];
    _thread.name = @"线程A";
    
    self.lock1 = [[NSLock alloc] init];
    self.lock2 = [[NSLock alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.thread start]
    [self test1];
}

- (void)runThread:(NSString *)str {
    
    [self deadLock];
    return;
    // 1. 获取当前线程
    NSThread * currentThread = [NSThread currentThread];

    NSLog(@"currentThread --- %@", currentThread);

    // 2. 阻塞 2s
    NSLog(@"线程开始阻塞 2s");

    [NSThread sleepForTimeInterval:2.0];

    NSLog(@"线程结束阻塞 2s");

    // 3. 阻塞 4s
    NSLog(@"线程开始阻塞 4s");

    // 创建 NSDate 对象，并从当前开始推后 4s
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:4.0];

    [NSThread sleepUntilDate:date];

    NSLog(@"线程结束阻塞 4s");

//    // 4. 退出线程
//    for (int i = 0; i < 10; ++i) {
//
//        if (i == 7) {
//
//            // 结束当前线程，之后的语句不会再执行
//            [NSThread exit];
//
//            NSLog(@"线程结束");
//         }
//         NSLog(@"%i --- %@", i, currentThread);
//    }
}


/**
 某个任务需要多个资源，比如资源 1、资源 2。此时，线程 A 与线程 B 都要执行这个任务。但是，线程 A 先抢占了资源 1，同时线程 B 抢占了资源 2。这个时候，线程 A 还需要资源 2 才能执行任务；同样的，线程 B 还需要资源 1 才能执行任务。于是，A 等 B，B 等 A，死锁来了。

 */
- (void)deadLock {
    
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(deadLock1) object:nil];
    [thread1 setName:@"【线程 汤姆】"];
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(deadLock2) object:nil];
    [thread2 setName:@"【线程 杰瑞】"];
    
    [thread1 start];
    [thread2 start];
}

- (void)doSomething {
    NSLog(@"%s", __FUNCTION__);
}

- (void)deadLock1 {
    
    [self.lock1 lock];
    NSLog(@"%@ 锁住 lock1", [NSThread currentThread]);
    
    // 线程休眠一秒
    [NSThread sleepForTimeInterval:1];
    
    [self.lock2 lock];
    NSLog(@"%@ 锁住 lock2", [NSThread currentThread]);

    
    [self doSomething];
    
    
    [self.lock2 unlock];
    NSLog(@"%@ 解锁 lock2", [NSThread currentThread]);
    
    [self.lock1 unlock];
    NSLog(@"%@ 解锁 lock1", [NSThread currentThread]);
}


- (void)deadLock2 {
    
    [self.lock2 lock];
    NSLog(@"%@ 锁住 lock2", [NSThread currentThread]);
    
    // 线程休眠一秒
    [NSThread sleepForTimeInterval:1];
    
    [self.lock1 lock];
    NSLog(@"%@ 锁住 lock1", [NSThread currentThread]);
    
    
    [self doSomething];
    
    
    [self.lock1 unlock];
    NSLog(@"%@ 解锁 lock1", [NSThread currentThread]);
    
    [self.lock2 unlock];
    NSLog(@"%@ 解锁 lock2", [NSThread currentThread]);
}

/**
 *直接执行  崩溃信息如下 线程未保活，start之后就销毁了  需保活
 *
 *** Terminating app due to uncaught exception 'NSDestinationInvalidException', reason: '*** -[ThreadController performSelector:onThread:withObject:waitUntilDone:modes:]: target thread exited while waiting for the perform'
 */
- (void)test1 {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
        
        /// 线程保活
//        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
    }];
    [thread start];
    
    [self performSelector:@selector(doSomething) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)test2 {
    NSMutableArray *arr = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_queue_create("cur", DISPATCH_QUEUE_CONCURRENT);
    Person *p = [Person new];
    Person *p1 = [Person new];
    for (int i = 0; i < 200; i++) {
        dispatch_async(queue, ^{
//            @synchronized (self) {
            // in -[__NSArrayM insertObject:atIndex:] ()
//            [arr addObject:p1]; // 崩溃 pointer being freed was not allocated
//            [arr addObject:@"123"]; // 崩溃 pointer being freed was not allocated
//            p.age = arc4random_uniform(100); // 不会崩溃
//            };
        });
    }
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
