//
//  LoginViewController.m
//  RAC-MVVMDemo
//
//  Created by MacBook on 2018/2/28.
//  Copyright © 2018年 nuanqing. All rights reserved.
//  登录界面MVVM&&RAC

#import "LoginViewController.h"
#import <ReactiveObjC.h>
#import "LoginView.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (nonatomic,strong) LoginView *loginView;

@property (nonatomic,strong) LoginViewModel *loginViewModel;

@end

@implementation LoginViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setupUI];
    [self dealWithButton];
    [self dealWithLogin];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loginView.userNameField becomeFirstResponder];
}



#pragma mark - UI

- (void)setNav{
    self.navigationItem.title = @"Login";
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupUI{
    [self.view addSubview:self.loginView];
}

- (void)dealWithButton{
    //传给loginViewModel判断loginButton是否可以点击
    RAC(self.loginViewModel,userName) = self.loginView.userNameField.rac_textSignal;
    RAC(self.loginViewModel,passWord) = self.loginView.passWordField.rac_textSignal;
    
    RAC(self.loginView.loginButton,enabled) = self.loginViewModel.btnEnableSignal;
    //按钮事件
    [[self.loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        //传递数据处理
        [self.loginViewModel.loginCommand execute:@{@"userName":self.loginView.userNameField.text,@"password":self.loginView.passWordField.text}];
        }];
}

- (void)dealWithLogin{
   
    //登陆成功
    [self.loginViewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        //获取数据
        NSLog(@"%@",x);
        //处理页面跳转
    }];
    //登录失败
    [self.loginViewModel.loginCommand.errors subscribeNext:^(NSError * _Nullable error) {
        //处理失败
        NSLog(@"%@",error.userInfo[@"error"]);
    }];
}


#pragma mark - 标记

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.loginView.userNameField resignFirstResponder];
    [self.loginView.passWordField resignFirstResponder];
}

#pragma mark - 懒加载

- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc]initWithFrame:self.view.frame];
    }
    return _loginView;
}

- (LoginViewModel *)loginViewModel{
    if (!_loginViewModel) {
        _loginViewModel = [[LoginViewModel alloc]init];
    }
    return _loginViewModel;
}

@end
