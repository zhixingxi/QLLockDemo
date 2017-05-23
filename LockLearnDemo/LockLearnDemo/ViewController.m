//
//  ViewController.m
//  LockLearnDemo
//
//  Created by MQL-IT on 2017/5/23.
//  Copyright © 2017年 MQL-IT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    //1.@synchronized 条件锁
    self.array = [NSMutableArray array];
    [self synchronized];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%@", self.array);
    });
}

//MARK: ======= 1.@synchronized 条件锁
// 你调用 sychronized 的每个对象，Objective-C runtime 都会为其分配一个递归锁并存储在哈希表中。

// 相当于是给代码块加锁,@synchronized{}中的代码不执行完成不会执行别处, @synchronized相对耗时比较多
- (void)synchronized {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            for (int i = 0; i < 5; i++) {
                [self.array addObject:@(i + 1)];
                 NSLog(@"%@", [NSThread currentThread]);
            }
        }
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @synchronized (self) {
            [self.array addObject:@"23"];
            NSLog(@"线程2: %@", [NSThread currentThread]);
        }
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
