//
//  NSObject+Common.h
//  子曰
//
//  Created by Martell on 15/11/24.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)
//显示失败提示
- (void)showErrorMsg:(NSObject *)msg;

//显示成功提示
- (void)showSuccessMsg:(NSObject *)msg;
- (void)showMsg:(NSObject *)msg;

//显示忙
- (void)showProgress;
- (void)showProgressOn:(UIView *)view;

//隐藏提示
- (void)hideProgress;
- (void)hideProgressOn:(UIView *)view;
@end
