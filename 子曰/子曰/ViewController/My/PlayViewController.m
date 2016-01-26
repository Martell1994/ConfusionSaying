//
//  PlayViewController.m
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "PlayViewController.h"
#import "MImageView.h"
#import "PlayView.h"

@interface PlayViewController ()
@property (nonatomic, strong) MImageView *songImageView;
@end

@implementation PlayViewController

- (MImageView *)songImageView {
    if (!_songImageView) {
        _songImageView = [[MImageView alloc] initWithFrame:CGRectMake(20, 120, kWindowW - 40, kWindowW - 40)];
    }
    return _songImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:_songImageView];
    [[PlayView sharedInstance].backBtn bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    //添加播放控制视图
    self.view.backgroundColor = kRGBColor(110, 153, 106);
    [self.view addSubview:[PlayView sharedInstance]];
    [[PlayView sharedInstance] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


@end
