//
//  LockController.m
//  INT
//
//  Created by yuehuig on 2021/10/19.
//

#import "LockController.h"
#import <libkern/OSAtomic.h> // 引入 OSSpinLock
#import <os/lock.h> // 引入 os_unfair_lock
#import <pthread.h> // 引入 pthread_mutex_t

@interface LockController ()
@property (nonatomic, assign) NSInteger sum;

@property (nonatomic, assign) OSSpinLock *osspinLock;
@property (nonatomic, assign) os_unfair_lock unfair_lock;
@property (nonatomic, assign) pthread_mutex_t pthread_mutex_lock;
@property (nonatomic, assign) pthread_rwlock_t pthread_rwlock;

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation LockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sum = 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self osspinLockT];
//    [self os_unfair_lockT];
//    [self pthread_mutex_lockT];
//    [self pthread_rwlockT];
    [self barrierAsync];
}

/**
 OSSpinLock
 
 OS_SPINLOCK_INIT 初始化。
 OSSpinLockTry() 尝试加锁，如果锁已经被另一个线程所持有则返回 false，否则返回 true，即使加锁失败也不会阻塞当前线程。
 OSSpinLockLock() 加锁，加锁失败会一直等待，会阻塞当前线程。
 OSSpinLockUnlock 解锁。

 如果一个低优先级的线程获得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，它会处于 spin lock 的忙等状态从而占用大量 CPU。此时低优先级线程无法与高优先级线程争夺 CPU 时间，从而导致任务迟迟完不成、无法释放 lock。
 */
- (void)osspinLockT {
    self.osspinLock = OS_SPINLOCK_INIT;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    __weak typeof(self) weakSelf = self;
    dispatch_async(globalQueue, ^{ // 异步任务 1
        OSSpinLockLock(&self->_osspinLock); // 获得锁
        for (unsigned int i = 0; i < 10000; ++i) {
            self.sum++;
        }
        NSLog(@"⏰⏰⏰ %ld", self.sum);
        OSSpinLockUnlock(&self->_osspinLock); // 解锁
    });
    
    dispatch_async(globalQueue, ^{ // 异步任务 2
        OSSpinLockLock(&self->_osspinLock); // 获得锁
        for (unsigned int i = 0; i < 10000; ++i) {
            self.sum++;
        }
        NSLog(@"⚽️⚽️⚽️ %ld", self.sum);
        OSSpinLockUnlock(&self->_osspinLock); // 解锁
    });
}

/**
 os_unfair_lock
 
 os_unfair_lock 设计宗旨是用于替换 OSSpinLock，从 iOS 10 之后开始支持，跟 OSSpinLock 不同，等待 os_unfair_lock 的线程会处于休眠状态（类似 Runloop 那样），不是忙等（busy-wait）
 
 */
- (void)os_unfair_lockT {
    self.unfair_lock = OS_UNFAIR_LOCK_INIT;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(globalQueue, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        os_unfair_lock_lock(&strongSelf->_unfair_lock);
        for (unsigned int i = 0; i < 10000; ++i) {
            strongSelf.sum++;
        }
        os_unfair_lock_unlock(&strongSelf->_unfair_lock);
        NSLog(@"⏰⏰⏰ %ld", strongSelf.sum);
    });
    
    dispatch_async(globalQueue, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        os_unfair_lock_lock(&strongSelf->_unfair_lock); // 加锁
        for (unsigned int i = 0; i < 10000; ++i) {
            strongSelf.sum++;
        }
        os_unfair_lock_unlock(&strongSelf->_unfair_lock); // 解锁
        NSLog(@"⚽️⚽️⚽️ %ld", strongSelf.sum);
    });

}

/**
 pthread_mutex_t
 
 pthread_mutex_t 初始化时使用不同的 pthread_mutexattr_t 可获得不同类型的锁。
 
 PTHREAD_MUTEX_NORMAL // 缺省类型，也就是普通类型，当一个线程加锁后，其余请求锁的线程将形成一个队列，并在解锁后先进先出原则获得锁。
 PTHREAD_MUTEX_ERRORCHECK // 检错锁，如果同一个线程请求同一个锁，则返回 EDEADLK，否则与普通锁类型动作相同。这样就保证当不允许多次加锁时不会出现嵌套情况下的死锁
 PTHREAD_MUTEX_RECURSIVE //递归锁，允许同一个线程对同一锁成功获得多次，并通过多次 unlock 解锁。
 PTHREAD_MUTEX_DEFAULT // 适应锁，动作最简单的锁类型，仅等待解锁后重新竞争，没有等待队列。

 
 */

- (void)pthread_mutex_lockT {
    
    // 1. 互斥锁，默认状态为互斥锁
    // 初始化属性
    pthread_mutexattr_t att;
    pthread_mutexattr_init(&att);
    
    // 设置属性，描述锁是什么类型
    pthread_mutexattr_settype(&att, PTHREAD_MUTEX_DEFAULT);
    
    // 初始化锁
    pthread_mutex_init(&self->_pthread_mutex_lock, &att);
    
    // 销毁属性
    pthread_mutexattr_destroy(&att);
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(globalQueue, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
    
        pthread_mutex_lock(&strongSelf->_pthread_mutex_lock);
        for (unsigned int i = 0; i < 10000; ++i) {
            strongSelf.sum++;
        }
        pthread_mutex_unlock(&strongSelf->_pthread_mutex_lock);
        
        NSLog(@"😵😵😵 %ld", (long)strongSelf.sum);
    });
    
    dispatch_async(globalQueue, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        
        pthread_mutex_lock(&strongSelf->_pthread_mutex_lock);
        for (unsigned int i = 0; i < 10000; ++i) {
            strongSelf.sum++;
        }
        pthread_mutex_unlock(&strongSelf->_pthread_mutex_lock);

        NSLog(@"👿👿👿 %ld", (long)strongSelf.sum);
    });
}

/**
 pthread_rwlock_t
 
 同时可以有多个线程读取。
 同时只能有一个线程写入。
 同时只能执行读取或者写入的一种
 
 
 读取加锁可以同时多个线程进行，写入同时只能一个线程进行，等待的线程处于休眠状态。

 pthread_rwlock_init() 初始化一个读写锁
 pthread_rwlock_rdlock() 读写锁的读取加锁
 pthread_rwlock_wrlock() 读写锁的写入加锁
 pthread_rwlock_unlock() 解锁
 pthread_rwlock_destroy() 销毁锁

 */
- (void)pthread_rwlockT {
    pthread_rwlockattr_t att;
    pthread_rwlockattr_init(&att);
    pthread_rwlock_init(&self->_pthread_rwlock, &att);
    pthread_rwlockattr_destroy(&att);
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __weak typeof(self) _self = self;
    for (unsigned int i = 0; i < 100; ++i) {
        // 同时创建多个线程进行写入操作
        dispatch_async(globalQueue, ^{
            __weak typeof(_self) self = _self;
            if (!self) return;
            
            [self lockWriteAction];
        });
        
        dispatch_async(globalQueue, ^{
            __weak typeof(_self) self = _self;
            if (!self) return;
            
            [self lockWriteAction];
        });
        
        dispatch_async(globalQueue, ^{
            __weak typeof(_self) self = _self;
            if (!self) return;
            
            [self lockWriteAction];
        });
        
        // 同时创建多个线程进行读操作
        dispatch_async(globalQueue, ^{
            __strong typeof(_self) self = _self;
            if (!self) return;
            
            [self lockReadAction];
        });
        
        dispatch_async(globalQueue, ^{
            __strong typeof(_self) self = _self;
            if (!self) return;
            
            [self lockReadAction];
        });
        
        dispatch_async(globalQueue, ^{
            __strong typeof(_self) self = _self;
            if (!self) return;
            
            [self lockReadAction];
        });
    }
}

- (void)lockReadAction {
    pthread_rwlock_rdlock(&self->_pthread_rwlock);
    sleep(1);
    NSLog(@"RWLock read action %@", [NSThread currentThread]);
    pthread_rwlock_unlock(&self->_pthread_rwlock);
}

- (void)lockWriteAction {
    pthread_rwlock_wrlock(&self->_pthread_rwlock);
    sleep(1);
    NSLog(@"RWLock Write Action %@", [NSThread currentThread]);
    pthread_rwlock_unlock(&self->_pthread_rwlock);
}

/**
 dispatch_barrier_async 实现多读单写
 
 传入的并发队列必须是手动创建的，dispatch_queue_create() 方式，如果传入串行队列或者通过 dispatch_get_global_queue() 方式创建，则 dispatch_barrier_async 的作用就跟 dispatch_async 变的一样。
 */

- (void)barrierAsync {
    self.queue = dispatch_queue_create("barrier_async", DISPATCH_QUEUE_CONCURRENT);
    
    for (unsigned int i = 0; i < 100; ++i) {
        
        // 同时创建多个线程进行写入操作
        [self barrierWriteAction];
        [self barrierWriteAction];
        [self barrierWriteAction];
        
        // 同时创建多个线程进行读取操作
        [self barrierReadAction];
        [self barrierReadAction];
        [self barrierReadAction];
    }

}

- (void)barrierReadAction {
    dispatch_sync(self.queue, ^{
        sleep(1);
        NSLog(@"barrier Read Action %@", [NSThread currentThread]);
    });
}

- (void)barrierWriteAction {
    // 写操作使用 dispatch_barrier_async
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"barrier Write Action %@", [NSThread currentThread]);
    });
}


- (void)dealloc {
    NSLog(@"🧑‍🎤🧑‍🎤🧑‍🎤 dealloc 同时释放🔒...");
    // 销毁锁
    pthread_mutex_destroy(&self->_pthread_mutex_lock);
    pthread_rwlock_destroy(&self->_pthread_rwlock);
}

@end
