//
//  ViewController.m
//  RACSignal
//
//  Created by MacBook on 2018/2/27.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()

@property (nonatomic,strong) RACSignal *signal;

@property (nonatomic,strong) RACDisposable *subscriber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建信号
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        //[subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"取消订阅");
        }];;
    }];
    //订阅信号
  [self.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"disposable:%@", x);
    }];

    
}

- (void)disposable{
    //强引用下使用
    //创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        [subscriber sendNext:@"1"];
        //强引用subscriber
        self.subscriber = subscriber;

        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    
    //订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"disposable:%@",x);
    }];
    
    //主动触发取消订阅(否则不会触发block)
    [disposable dispose];
    //在发送订阅的时候会给我们一个RACDisposable对象，
    //我们拿到它，然后调用 [disposable dispose]; 这个方法
}
/**
 *  RACSignal总结：
 一.核心：
 1.核心：信号类
 2.信号类的作用：只要有数据改变就会把数据包装成信号传递出去
 3.只要有数据改变就会有信号发出
 4.数据发出，并不是信号类发出，信号类不能发送数据
 一.使用方法：
 1.创建信号
 2.订阅信号
 二.实现思路：
 1.当一个信号被订阅，创建订阅者，并把nextBlock保存到订阅者里面。
 2.创建的时候会返回 [RACDynamicSignal createSignal:didSubscribe];
 3.调用RACDynamicSignal的didSubscribe
 4.发送信号[subscriber sendNext:value];
 5.拿到订阅者的nextBlock调用
 */


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self disposable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
