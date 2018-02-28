//
//  ViewController.m
//  RACCommand
//
//  Created by MacBook on 2018/2/27.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//RACCommand: RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程
- (void)command1{
    // 不能返回空的信号
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //得到命令
        //输出2
        NSLog(@"input:%@",input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            if (input) {
                //根据命令发送信号
                [subscriber sendNext:@"command1执行命令产生数据"];
            }
            return nil;
        }];
    }];
    
    //方式一:
    //执行命令
    RACSignal *signal = [command execute:@"2"];
    //订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        //输出执行命令产生数据
        NSLog(@"%@",x);
    }];
    
    //方式二:
    [command.executionSignals subscribeNext:^(RACSignal *signal) {
        [signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }];
    [command execute:@"3"];
    
    //方式三:
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
     [command execute:@"4"];
}

// 监听事件有没有完成
- (void)command2{
    //注意：当前命令内部发送数据完成，一定要主动发送完成
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *_Nonnull(id  _Nullable input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *_Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            // 发送数据
            [subscriber sendNext:@"command2执行命令产生的数据"];
            
            // *** 发送完成 **
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    // 监听事件有没有完成
    [command.executing subscribeNext:^(id _Nullable x) {
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行");
        }
    }];
    //订阅信号
    [command.executionSignals subscribeNext:^(RACSignal *signal) {
        [signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }];
    // 2.执行命令
    [command execute:@"1"];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self command1];
    [self command2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
