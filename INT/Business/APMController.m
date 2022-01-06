//
//  APMController.m
//  INT
//
//  Created by yuehuig on 2021/12/2.
//

#import "APMController.h"

@interface APMController ()
@property (nonatomic, assign) CFRunLoopObserverRef observer;

@end

@implementation APMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self notsmooth];
}

/**
 Run Loop Observer Activities
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     kCFRunLoopAllActivities = 0x0FFFFFFFU
 };
 */
//typedef void (*CFRunLoopObserverCallBack)(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);
void observerCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSString *activityStr = @"";
    switch (activity) {
        case kCFRunLoopEntry:
            activityStr = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            activityStr = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            activityStr = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            activityStr = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            activityStr = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            activityStr = @"kCFRunLoopExit";
            break;
        default:
            activityStr = @"kCFRunLoopAllActivities";
            break;
    }
    NSLog(@"call back - activity: %@", activityStr);
};

- (void)notsmooth {
    /**
     typedef struct {
         CFIndex    version;
         void *    info;
         const void *(*retain)(const void *info);
         void    (*release)(const void *info);
         CFStringRef    (*copyDescription)(const void *info);
     } CFRunLoopObserverContext;
     */
    // 设置Runloop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            0,
                                                            &observerCallBack,
                                                            &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    _observer = observer;
}


@end
