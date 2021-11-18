//
//  ObserveController.m
//  INT
//
//  Created by yuehuig on 2021/10/25.
//

#import "ObserveController.h"
#import "Person.h"

@interface ObserveController ()
@property (nonatomic, strong) Person *person;
@end

@implementation ObserveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [Person new];
    self.person.observeTest = @"observeTest_1";
    [self.person addObserver:self forKeyPath:@"observeTest" options:NSKeyValueObservingOptionNew context:NULL];
    [self.person addObserver:self forKeyPath:@"observeTest" options:NSKeyValueObservingOptionNew context:NULL];
    [self.person addObserver:self forKeyPath:@"observeTest" options:NSKeyValueObservingOptionNew context:NULL];
}

/**
 * 未实现 observeValueForKeyPath 会造成崩溃
 *
 *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: '<ObserveController: 0x7fcb3070f750>: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.
 Key path: observeTest
 Observed object: <Person: 0x600003982f40>
 Change: {
     kind = 1;
     new = "observeTest_2";
 }
 Context: 0x0'
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"observe => %@", change);
}

/**
 问题1
 问 KVO 动态生成的新类重写了属性的 Setter 函数后，那原始手动实现的 Setter 函数会被覆盖吗
 
 不会覆盖   派生类中重写的setter方式中调用了 [super setValue:obj] 不会影响手动实现的setter
 
 问题2
 对对象的某个属性添加观察者后那对象的 isa 指向和 class 函数会发生什么变化
 
 当 person 被观察后，person 对象的 isa 指针被指向了一个新建的 Person 的子类 NSKVONotifying_Person，且这个子类重写了被观察属性的 setter 方法、class 方法、dealloc 和 _isKVO 方法，然后使 person 对象的 isa 指针指向这个新建的类，然后事实上 person 变为了NSKVONotifying_Person 的实例对象，执行方法要从这个类的方法列表里找。dealloc 方法：观察者移除后使 class 变回去 Person（通过 isa 指向）, _isKVO 方法判断被观察者自己是否同时也观察了其他对象。（同时苹果警告我们，通过 isa 获取类的类型是不可靠的，通过 class 方法才能得到正确的类）

 
 
 -(void)setValue:(id)obj {
     [self willChangeValueForKey:@"keyPath"];
     
     // 这里内部使用 super 调用，由于当前派生类的 super 正是指向原类，所以不影响原类中自己手动实现的 setter 函数调用（去 58 面试时遇到了这个问题）
     [super setValue:obj];
     
     [self didChangeValueForKey:@"keyPath"];
 }

 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.observeTest = @"observeTest_2";
}

- (void)dealloc {
    /**
     ⚠️⚠️⚠️ 切记不能多次移除观察者 会报如下错误
     
     [general] Caught exception during runloop's autorelease pool drain of client objects NSRangeException: Cannot remove an observer <ObserveController 0x7fbbb83130e0> for the key path "observeTest" from <Person 0x600003aa26d0> because it is not registered as an observer. userInfo: (null)
     2021-11-10 10:36:44.674856+0800 INT[70986:7808838] *** Terminating app due to uncaught exception 'NSRangeException', reason: 'Cannot remove an observer <ObserveController 0x7fbbb83130e0> for the key path "observeTest" from <Person 0x600003aa26d0> because it is not registered as an observer.'
     */
//    [self.person removeObserver:self forKeyPath:@"observeTest"];
    [self.person removeObserver:self forKeyPath:@"observeTest"];
}

@end
