//
//  ThreadController.m
//  INT
//
//  Created by yuehuig on 2021/8/25.
//

#import "ThreadController.h"
#import "YHThread.h"

@interface ThreadController ()
@property (nonatomic, strong) YHThread *thread;

@end

@implementation ThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 1. 初始化线程对象
     _thread = [[YHThread alloc] initWithTarget:self selector:@selector(runThread:) object:@"子线程执行任务"];
    _thread.name = @"线程A";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.thread start];
}

- (void)runThread:(NSString *)str {

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


@end
