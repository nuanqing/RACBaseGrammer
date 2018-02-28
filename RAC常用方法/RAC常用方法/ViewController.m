//
//  ViewController.m
//  RAC常用方法
//
//  Created by MacBook on 2018/2/27.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "CustomView.h"

@interface ViewController ()

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) CustomView *customView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setTextField];
    [self setButton];
    [self setKVO];
    [self setNofication];
    [self setRACCommand];
}

- (void)setupUI{
    [self.view addSubview:self.textField];
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    [self.view addSubview:self.customView];
    //代理方法,订阅信号
    [self.customView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)setNofication{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"post" object:nil userInfo:@{@"text":@"hello world"}];
    //通知
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"post" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x.userInfo[@"text"]);
    }];
}

- (void)setTextField{
    //监听textField的text
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        NSLog(@"textField:%@",text);
    }];
    //动态改变label的值与textField的值一致(注意时机)
    RAC(self.label,text) = self.textField.rac_textSignal;
    
    
    //filter:过滤器，添加过滤条件
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        //value为文本内容text
        // 只有当文本框的内容长度大于5，才获取文本框里的内容
        BOOL isOutPut = [value length] >5;
        return isOutPut;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter:%@",x);
    }];
}

- (void)setButton{
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton *btn) {
        NSLog(@"click--%@",btn);
       
    }];
}

- (void)setKVO{
    //方法一:
    [[self.label rac_valuesAndChangesForKeyPath:@"text" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable tuple) {
        NSDictionary *dict = [tuple last];
        NSLog(@"%@-----%@",tuple,dict[@"new"]);
    }];
    
    //方法二:
    [[self.label rac_valuesForKeyPath:@"text" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //方法三:
    [RACObserve(self.label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //写法二、写法三程序运行的时候就会监听到,方法一值改变后会监听到
}

- (void)setRACCommand{
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

#pragma mark - 懒加载

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.frame = CGRectMake(100, 80, 100, 30);
        _textField.placeholder = @"input";
    }
    return _textField;
}

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc]init];
        _button.frame = CGRectMake(100, 120, 80, 30);
        _button.backgroundColor = [UIColor redColor];
        [_button setTitle:@"click" forState:UIControlStateNormal];
    }
    return _button;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.frame = CGRectMake(100, 180, 200, 50);
        _label.backgroundColor = [UIColor redColor];
    }
    return _label;
}


- (CustomView *)customView{
    if (!_customView) {
        _customView = [[CustomView alloc]init];
        _customView.frame = CGRectMake(100, 270, 200, 200);
        _customView.backgroundColor = [UIColor blueColor];
    }
    return _customView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
