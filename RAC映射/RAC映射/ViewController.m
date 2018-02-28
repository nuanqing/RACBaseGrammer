//
//  ViewController.m
//  RAC映射
//
//  Created by MacBook on 2018/2/26.
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

- (void)map{
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //绑定信号
    RACSignal *bindSignal = [subject map:^id _Nullable(id  _Nullable value) {
        //映射的值value
        return value;
    }];
    //订阅信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        //依次输出map,value
        NSLog(@"map:%@",x);
    }];
    //发送信号
    [subject sendNext:@"map"];
    [subject sendNext:@"value"];
}

- (void)flattenMap{
    //写法一:
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //绑定信号
    RACSignal *bindSignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        // block：只要源信号发送内容就会调用
        // value: 就是源信号发送的内容
        // 返回信号用来包装成修改内容的值
        return [RACSignal return:value];
    }];
    //订阅信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        //依次为flattenMap,value
        NSLog(@"flattenMap:%@",x);
    }];
    //发送信号
    [subject sendNext:@"flattenMap"];
    [subject sendNext:@"value"];
    
    //写法二：
    RACSubject *subject2 = [RACSubject subject];
    [[subject2 flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACSignal return:value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"flattenMap2:%@",x);
    }];
    [subject2 sendNext:@"flattenMap2"];
    
    //写法三：
    RACSubject *subject3 = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [[subject3 flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"flattenMap3:%@",x);
    }];
    
    [subject3 sendNext:signal];
    //注意：这里为signal
    [signal sendNext:@"flattenMap3"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self map];
    [self flattenMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
