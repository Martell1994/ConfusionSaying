//
//  Factory.m
//  子曰
//
//  Created by Martell on 15/11/12.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "Factory.h"

@implementation Factory

+ (void)addBackItemToVC:(UIViewController *)vc {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"vc_back_n"] forState:UIControlStateNormal];
    //[btn setImage:[UIImage imageNamed:@"vc_back_h"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 28, 28);
    [btn bk_addEventHandler:^(id sender) {
        [vc.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    menuItem.tintColor = kRGBColor(110, 153, 106);
    //使用弹簧控件缩小菜单按钮和边缘距离
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -6;
    vc.navigationItem.leftBarButtonItems = @[spaceItem,menuItem];
    
}


@end
