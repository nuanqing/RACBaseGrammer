//
//  ViewController.m
//  RAC宏
//
//  Created by MacBook on 2018/2/27.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //RAC宏
    //把一个对象的某个属性绑定一个信号,只要发出信号,就会把信号的内容给对象的属性赋值
    //将textfield的text赋值给titleLabel的text
    RAC(self.titleLabel,text) = self.textField.rac_textSignal;
    //监听KVO
    @weakify(self)
    [RACObserve(self.titleLabel, text) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSLog(@"%@---%@",x,self.titleLabel.text);
    }];
    
}
//元组
- (void)tuple{
    //包装
    RACTuple *tuple = RACTuplePack(@1,@2,@3);
    //解包赋值
    RACTupleUnpack_(NSNumber *num1, NSNumber *num2, NSNumber * num3) = tuple;
    NSLog(@"%@--%@--%@",num1,num2,num3);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self tuple];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
