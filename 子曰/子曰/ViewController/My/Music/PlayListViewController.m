//
//  PlayListViewController.m
//  子曰
//
//  Created by Martell on 16/2/23.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "PlayListViewController.h"

@interface PlayListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PlayListViewController
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView.backgroundColor = [UIColor redColor];
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kWindowH / 3);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kWindowH / 3 * 2);
        }];
    }
    return _tableView;
}
- (void)addNavView{
    
    UIView *navView = [[UIView alloc]init];
    navView.backgroundColor = [UIColor greenColor];
    [_tableView addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"播放列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"关闭" style:UIBarButtonItemStyleDone handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIView *iv = [[UIView alloc]init];
    [self.view addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    iv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = @"测试语句";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
