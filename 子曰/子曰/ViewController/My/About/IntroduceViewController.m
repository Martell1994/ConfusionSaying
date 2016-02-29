//
//  IntroduceViewController.m
//  子曰
//
//  Created by Martell on 16/2/17.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能介绍";
    [Factory addBackItemToVC:self];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, NaviHeight + 10, kWindowW - 20, 30)];
    label.text = @"暂无功能介绍";
    [self.view addSubview:label];
}

@end
