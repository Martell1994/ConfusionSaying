//
//  NSObject+Common.m
//  子曰
//
//  Created by Martell on 15/11/24.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "NSObject+Common.h"
#define kToastDuration     1

@implementation NSObject (Common)

//显示失败提示
- (void)showErrorMsg:(NSObject *)msg{
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.labelText = msg.description;
    [progressHUD hide:YES afterDelay:kToastDuration];
}

//显示成功提示
- (void)showSuccessMsg:(NSObject *)msg{
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.labelText = msg.description;
    [progressHUD hide:YES afterDelay:kToastDuration];
}

- (void)showMsg:(NSObject *)msg OnView:(UIView *)view {
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.labelText = msg.description;
    [progressHUD hide:YES afterDelay:kToastDuration];
}

//显示忙
- (void)showProgress{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    [progressHUD hide:YES afterDelay:kToastDuration];
}

- (void)showProgressOn:(UIView *)view {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [progressHUD hide:YES afterDelay:kToastDuration];
}

//隐藏提示
- (void)hideProgress{
    [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
}

- (UIView *)currentView{
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([controller isKindOfClass:[UITabBarController class]]) {
        controller = [(UITabBarController *)controller selectedViewController];
    }
    if([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller visibleViewController];
    }
    if (!controller) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return controller.view;
}

@end
