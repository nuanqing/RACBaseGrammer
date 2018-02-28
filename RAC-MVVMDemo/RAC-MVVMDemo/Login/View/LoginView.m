//
//  LoginView.m
//  RAC-MVVMDemo
//
//  Created by MacBook on 2018/2/28.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [self addSubview:self.userNameField];
    [self addSubview:self.passWordField];
    [self addSubview:self.loginButton];
}


#pragma mark - 懒加载

- (UITextField *)userNameField{
    if (!_userNameField) {
        _userNameField = [[UITextField alloc]init];
        _userNameField.frame = CGRectMake(0, 0, 260, 40);
        _userNameField.center = CGPointMake(self.center.x, 200);
        _userNameField.placeholder = @"phoneNumber";
        _userNameField.layer.cornerRadius = 3;
        _userNameField.layer.masksToBounds = YES;
        _userNameField.backgroundColor = [UIColor whiteColor];
        _userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _userNameField;
}

- (UITextField *)passWordField{
    if (!_passWordField) {
        _passWordField = [[UITextField alloc]init];
        _passWordField.frame = CGRectMake(0, 0, 260, 40);
        _passWordField.center = CGPointMake(self.center.x, 260);;
        _passWordField.placeholder = @"passWord";
        _passWordField.layer.cornerRadius = 3;
        _passWordField.layer.masksToBounds = YES;
        _passWordField.backgroundColor = [UIColor whiteColor];
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordField.secureTextEntry = YES;
    }
    return _passWordField;
}


- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        _loginButton.frame = CGRectMake(0, 0, 100, 50);
        _loginButton.center = CGPointMake(self.center.x, 350);
        [_loginButton setTitle:@"login" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[self createImageWithColor:[[UIColor blueColor]colorWithAlphaComponent:0.3]] forState:UIControlStateDisabled];
        _loginButton.layer.cornerRadius = 5;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setBackgroundImage:[self createImageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    }
    return _loginButton;
}

//颜色生成图片
- (UIImage*) createImageWithColor:(UIColor*) color
{
    //获取尺寸
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘制
    UIGraphicsEndImageContext();
    return theImage;
}

@end
