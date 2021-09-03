//
//  KeyWordController.m
//  INT
//
//  Created by yuehuig on 2021/8/30.
//

#import "KeyWordController.h"

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


@end
