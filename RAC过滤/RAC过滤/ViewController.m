//
//  ViewController.m
//  RAC过滤
//
//  Created by MacBook on 2018/2/26.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@property (nonatomic,copy) NSString *userName;

@property (nonatomic,strong) UITextField *textFiled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.textFiled];
    
    
}
//RACSubject 信号提供者，自己可以充当信号，又能发送信号。

//过程包括：创建信号提供者->订阅->发送信号

//跳跃:跳过skip传入数字之前的值,得到传入数字之后的值
//在实际开发中比如 后台返回的数据前面几个没用，我们想跳跃过去，便可以用skip
- (void)skip{
    //创建信号提供者
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        //订阅
        NSLog(@"skip:%@",x);
    }];
    //发送信号
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
}
//distinctUntilChanged:-- 如果当前的值跟上一次的值一样，就不会被订阅到
- (void)distinctUntilChanged{
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged]subscribeNext:^(id  _Nullable x) {
        NSLog(@"distinctUntilChanged:%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    //不会被订阅
    [subject sendNext:@"2"];
}

//take:获取take传入数字之前的值
- (void)take{
    RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"take:%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
}

//takeLast:反向获取takeLast传入数字之前的值,需要调用sendCompleted告诉信号提供者发送完成了，这样才能取到最后的几个值
- (void)takeLast{
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        //2,3
        NSLog(@"takeLast:%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendCompleted];
}

// takeUntil:---给takeUntil传的是哪个信号，那么当这个信号发送信号或sendCompleted，就不能再接受源信号的内容
- (void)takeUntil{
    RACSubject *subject = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    [[subject takeUntil:subject2] subscribeNext:^(id  _Nullable x) {
        //1,2
        NSLog(@"takeUntil:%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject2 sendNext:@"3"];
    [subject sendNext:@"4"];
}

//忽略某个或所有的值
- (void)ignore{
    RACSubject *subject = [RACSubject subject];
    RACSignal *ignoreSignal = [subject ignore:@"2"];
    //忽略所有的值
    //    RACSignal *ignoreSignal = [subject ignoreValues];
    [ignoreSignal subscribeNext:^(id  _Nullable x) {
        //1,3
        NSLog(@"ignore:%@",x);
    }];
    [subject sendNext:@"1"];
    //忽略
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
}
//filter:过滤器，添加过滤条件
- (void)filter{
    [[self.textFiled.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        //value为文本内容text
        // 只有当文本框的内容长度大于5，才获取文本框里的内容
        BOOL isOutPut = [value length] >5;
        return isOutPut;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter:%@",x);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self skip];
    [self distinctUntilChanged];
    [self take];
    [self takeLast];
    [self takeUntil];
    [self ignore];
    [self filter];
}

- (UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
        _textFiled.textColor = [UIColor redColor];
        _textFiled.placeholder = @"输入";
        _textFiled.borderStyle = UITextBorderStyleLine;
        _textFiled.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.1];
    }
    return _textFiled;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

