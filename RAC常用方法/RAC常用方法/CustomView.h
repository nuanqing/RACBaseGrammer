//
//  CustomView.h
//  RAC常用方法
//
//  Created by MacBook on 2018/2/27.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

@interface CustomView : UIView

@property (nonatomic,strong) RACSubject *subject;

@end
