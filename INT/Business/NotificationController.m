//
//  NotificationController.m
//  INT
//
//  Created by yuehuig on 2021/11/2.
//

#import "NotificationController.h"

/**
 *  通知的接收和发送是在一个线程里
 
 实际上发送通知都是同步的，不存在异步操作。而所谓的异步发送，也就是延迟发送，在合适的实际发送。

 实现异步发送：

 让通知的执行方法异步执行即可 通过NSNotificationQueue，将通知添加到队列当中，立即将控制权返回给调用者，在合适的时机发送通知，从而不会阻塞当前的调用
 *
 *
 */

@interface NotificationController ()

@end

@implementation NotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"TestNotification" object:@1];
    
    [self test3];
}

/// 存储是以name和object为维度的
/// 此处是接收不到通知的
- (void)handleNotification:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [NSNotificationCenter.defaultCenter postNotificationName:@"TestNotification" object:nil];
    
    //2.发送通知
    /**
     *  Name:通知名字
     object：谁发出的通知
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:nil];
    
}

- (void)test3{
   
     //方法一：异步监听通知
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNote) name:@"note" object:nil];
    });
    
}

/**
 *  ===> 接收通知代码，由发布通知线程决定
 *
 *
 *  监听到通知就会调用
    异步：监听通知 主线程：发出通知
 //总结：接收通知代码，由发布通知线程决定
 */
- (void)reciveNote {
    NSLog(@"%@",[NSThread currentThread]);
    
    //注意点：如果是在异步发送通知，如果需要更新UI，为了安全起见，需要回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"%@",[NSThread currentThread]);
        //打印结果：<_NSMainThread: 0x600003bd8280>{number = 1, name = main}

    });
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
