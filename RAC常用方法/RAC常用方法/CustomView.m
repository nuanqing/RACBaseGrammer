//
//  CustomView.m
//  RAC常用方法
//
//  Created by MacBook on 2018/2/27.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIButton * button = [[UIButton alloc]init];
    button.frame = CGRectMake(40, 40, 120, 120);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"customClick" forState:UIControlStateNormal];
    [self addSubview:button];
    //代替代理
    self.subject = [RACSubject subject];
    @weakify(self);
    //发送信号
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.subject sendNext:@"传值"];
    }];
    
    
    
}



@end
