//
//  ViewController.m
//  RAC绑定
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
   
}

- (void)bind{
    RACSubject *subject = [RACSubject subject];
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock _Nonnull{
        
        return ^RACSignal *(id value,BOOL *stop){
            //最初的值
            NSLog(@"接收到的最初值：%@", value);
            value = @3; // 如果在这里把value的值改了，那么订阅绑定信号的值即44行的x就变了
            NSLog(@"改变后的值：%@", value);
            //返回信号，不能为nil,如果非要返回空---则empty或 alloc init
            // 把返回的值包装成信号
            return [RACSignal return:value];
        };
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到绑定信号处理完的值:%@", x);
    }];
    //发送信号
    [subject sendNext:@"111"];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self bind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
