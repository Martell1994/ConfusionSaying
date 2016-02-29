//
//  SuggestViewController.m
//  子曰
//
//  Created by Martell on 16/2/15.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "SuggestViewController.h"
#import "MTextView.h"

@interface SuggestViewController ()<UITextViewDelegate>

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈意见";
    self.view.backgroundColor = kRGBColor(231, 231, 231);
    MTextView *textView = [[MTextView alloc] initWithFrame:CGRectMake(10, NaviHeight + 10, kWindowW - 20, 120)];
    self.automaticallyAdjustsScrollViewInsets = NO;//解决由导航栏导致的textView高度减去NaviHeight的问题
    textView.backgroundColor = [UIColor whiteColor];
    textView.myPlaceholder = @"感谢反馈，请写下你的问题或意见";
    textView.myPlaceholderColor = [UIColor lightGrayColor];
    [self.view addSubview:textView];
    textView.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发送" style:UIBarButtonItemStyleDone handler:^(id sender) {
        BmobObject *suggest = [[BmobObject alloc] initWithClassName:@"ZY_Suggestion"];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [suggest setObject:delegate.userId forKey:@"userId"];
        [suggest setObject:textView.text forKey:@"sugContent"];
        [suggest saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [self showSuccessMsg:@"发送成功"];
                textView.text = @"";
            } else {
                [self showErrorMsg:@"发送失败"];
            }
        }];
    }];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [Factory addBackItemToVC:self];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.hasText) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
