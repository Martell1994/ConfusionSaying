//
//  NotiDetailViewController.m
//  子曰
//
//  Created by Martell on 16/2/17.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NotiDetailViewController.h"

@interface NotiDetailViewController ()

@end

@implementation NotiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Factory addBackItemToVC:self];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *contentLabel = [UILabel new];
    [self.view addSubview:contentLabel];
    contentLabel.text = self.content;
    CGSize maximumSize =CGSizeMake(kWindowW,999);
    UIFont *font =[UIFont fontWithName:@"Helvetica" size:14];
    CGSize StringSize =[self.content sizeWithFont:font
                                  constrainedToSize:maximumSize
                                      lineBreakMode:contentLabel.lineBreakMode];
    CGRect dateFrame =CGRectMake(10,NaviHeight + 10,kWindowW - 20, StringSize.height);
    contentLabel.frame = dateFrame;
}

@end
