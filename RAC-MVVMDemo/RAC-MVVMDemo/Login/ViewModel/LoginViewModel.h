//
//  LoginViewModel.h
//  RAC-MVVMDemo
//
//  Created by MacBook on 2018/2/28.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface LoginViewModel : NSObject

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *passWord;

@property (nonatomic, strong) RACSignal *btnEnableSignal;

@property (nonatomic, strong) RACCommand *loginCommand;
@end
