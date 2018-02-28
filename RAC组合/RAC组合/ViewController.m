//
//  ViewController.m
//  RAC组合
//
//  Created by MacBook on 2018/2/26.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self combineLast];
}
//多个信号的聚合，如：当两个输入框的验证。
- (void)combineLast{
    RACSignal *combinSignal = [RACSignal combineLatest:@[self.textField1.rac_textSignal,self.textField2.rac_textSignal] reduce:^id _Nonnull(NSString *text1,NSString*text2){
        //reduce里的参数一定要和combineLatest数组里的一一对应。
        NSLog(@"textField1:%@/ntextField2:%@",text1,text2);
        if (text1.length>6&&text2.length>6&&[text1 isEqualToString:text2]) {
            return @1;
        }
        return @0;
    }];
    //写法一:
    //RAC宏定义的方式
    RAC(self.sureButton,enabled) = combinSignal;
    //写法二:
    [combinSignal subscribeNext:^(id  _Nullable x) {
        self.sureButton.enabled = [x boolValue];
    }];
}

//zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的订阅事件
//使用场景:当一个界面多个请求的时候，要等所有请求完成才更新UI将[signalA sendNext:xxx]写在完成回调中
- (void)zipWith{
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    //把两个信号压缩成一个信号
    RACSignal *zipSignal = [signalA zipWith:signalB];
    [zipSignal subscribeNext:^(id  _Nullable x) {
        //x被包装成元组数据
        RACTwoTuple *tuple = x;
        NSLog(@"zipWith:%@,tupleA:%@,tupleB:%@",x,tuple[0],tuple[1]);
    }];
    //两个信号同时发出信号内容才有效
    [signalA sendNext:@"1"];
    [signalB sendNext:@"2"];
}

// merge:多个信号合并成一个信号，任何一个信号有新值就会调用
- (void)merge{
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    //组合信号
    RACSignal *mergeSignal = [signalA merge:signalB];
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        //依次输出1,2,3
        NSLog(@"merge:%@",x);
    }];
    //不需要两个信号同时发出信号
    [signalA sendNext:@"1"];
    [signalB sendNext:@"2"];
    [signalA sendNext:@"3"];
}

// then --- 使用需求：有两部分数据：想让上部分先进行网络请求但是过滤掉数据，然后进行下部分的，拿到下部分数据
- (void)then{
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 发送请求
        NSLog(@"----发送上部分请求---afn");
        
        [subscriber sendNext:@"上部分数据"];
        // 必须要调用sendCompleted方法,信号完成的发送
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 创建信号B
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 创建组合信号
    // then;忽略掉第一个信号的所有值
    RACSignal *thenSignal = [signalA then:^RACSignal *{
        // 返回的信号就是要组合的信号
        return signalsB;
    }];
    
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"then:%@", x);
    }];
}

// concat----- 使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行（都可获取值）
- (void)concat {
    // 组合
    
    // 创建信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        //        NSLog(@"----发送上部分请求---afn");
        
        [subscriber sendNext:@"上部分数据"];
        // 必须要调用sendCompleted方法,信号完成的发送
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 创建信号B，
    RACSignal *signalsB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        //        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        //可以不写
        //[subscriber sendCompleted];
        return nil;
    }];
    
    
    // concat:按顺序去链接
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [signalA concat:signalsB];
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"concat:%@",x);
    }];
    
}

- (IBAction)sureButtonClick:(id)sender {
    NSLog(@"sure");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self zipWith];
    [self merge];
    [self then];
    [self concat];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
