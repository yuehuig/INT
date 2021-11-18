//
//  KeyWordController.m
//  INT
//
//  Created by yuehuig on 2021/8/30.
//

#import "KeyWordController.h"
#import "Person.h"

static int age = 10;

@interface TEMPPerson : NSObject
-(void)add;
+(void)reduce;
@end

@implementation TEMPPerson

- (void)add {
    age++;
    NSLog(@"Person内部:%@-%p--%d", self, &age, age);
}

+ (void)reduce {
    age--;
    NSLog(@"Person内部:%@-%p--%d", self, &age, age);
}
@end


@implementation TEMPPerson (WY)

- (void)wy_add {
    age++;
    NSLog(@"Person (wy)内部:%@-%p--%d", self, &age, age);
}

@end

@interface KeyWordController ()

@end

@implementation KeyWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
    [self test2];
}

- (void)test1 {
    NSLog(@"vc:%p--%d", &age, age);
    age = 40;
    NSLog(@"vc:%p--%d", &age, age);
    [[TEMPPerson new] add];
    NSLog(@"vc:%p--%d", &age, age);
    [TEMPPerson reduce];
    NSLog(@"vc:%p--%d", &age, age);
    [[TEMPPerson new] wy_add];
}

- (void)test2 {
    Person *p1 = [Person new];
    Person *p2 = [Person new];
    
    p1.testCopy = @"xxx";
    p2.testCopy = p1.testCopy;
    NSLog(@"=> %@, %@", p1.testCopy, p2.testCopy);
    
    p2.testCopy = @"yyy";
    NSLog(@"=> %@, %@", p1.testCopy, p2.testCopy);
}

@end
