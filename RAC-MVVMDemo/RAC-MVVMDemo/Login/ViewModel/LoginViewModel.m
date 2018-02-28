//
//  LoginViewModel.m
//  RAC-MVVMDemo
//
//  Created by MacBook on 2018/2/28.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dealWithButton];
        [self dealWithLogin];
    }
    return self;
}

//处理点击的逻辑
- (void)dealWithButton{
    _btnEnableSignal = [RACSignal combineLatest:@[RACObserve(self, userName),RACObserve(self, passWord)] reduce:^(NSString *userName,NSString *passWord){
        //userName.length>6&&passWord.length>6才可以点击
        return @(userName.length>6&&passWord.length>6);
    }];
}
//处理登录逻辑
- (void)dealWithLogin{
     @weakify(self);
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        //对userName以及passWord验证
        if (![self isValidMobile:self.userName]) {
            return [RACSignal error:[NSError errorWithDomain:@"errorDomain" code:-1 userInfo:@{@"error":@"输入正确的手机号"}]];
        }
        if (![self isValidContainCharacterAndNumber:self.passWord]) {
            return [RACSignal error:[NSError errorWithDomain:@"errorDomain" code:-1 userInfo:@{@"error":@"密码为数字字母组合"}]];
        }
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //模拟处理网络
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"开始请求");
                NSLog(@"请求成功");
                NSLog(@"处理并保存数据");
                [subscriber sendNext:@"请求完成，传回数据"];
                [subscriber sendCompleted];
                //网络请求失败
                [subscriber sendError:[NSError errorWithDomain:@"errorDomain" code:-1 userInfo:@{@"error":@"请求数据失败,请重试"}]];
            });
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"结束");
            }];
        }];
    }];
}

- (BOOL)isValidMobile:(NSString *)str
{
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:str];
}

/// 字符串包含字母与数字
- (BOOL)isValidContainCharacterAndNumber:(NSString *)str
{
    NSString *regexCharacter = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]+$";
    NSPredicate *predicateCharacter = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexCharacter];
    return [predicateCharacter evaluateWithObject:str];
}


@end
