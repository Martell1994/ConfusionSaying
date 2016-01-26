//
//  MusicViewController.m
//  子曰
//
//  Created by Martell on 15/11/3.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicCategoryCell.h"
#import "MusicCategoryViewModel.h"
#import "MusicListViewController.h"

@interface MusicViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MusicCategoryViewModel *musicCategoryVM;
@end

@implementation MusicViewController

- (MusicCategoryViewModel *)musicCategoryVM {
    if (!_musicCategoryVM) {
        _musicCategoryVM = [MusicCategoryViewModel new];
    }
    return _musicCategoryVM;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MusicCategoryCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NaviHeight);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _tableView;
}

+ (UINavigationController *)defaultNavi {
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MusicViewController *vc = [MusicViewController new];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"丝竹榜单";
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_bg"]];
    self.tableView.backgroundView.alpha = 0.6;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.musicCategoryVM refreshDataCompletionHandle:^(NSError *error) {
            if (error) {
                [self showErrorMsg:error.localizedDescription];
            } else {
                [self.tableView reloadData];
            }
            [_tableView.mj_footer resetNoMoreData];
            [_tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.musicCategoryVM getMoreDataCompletionHandle:^(NSError *error) {
            if (error) {
                [self showErrorMsg:error.localizedDescription];
                if (error.code == 999) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_tableView.mj_header endRefreshing];
                }
            } else {
                [self.tableView reloadData];
                [_tableView.mj_footer endRefreshing];
            }
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicCategoryVM.rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.titleLb.text = [self.musicCategoryVM titleForRow:indexPath.row];
    cell.descLb.text = [self.musicCategoryVM descForRow:indexPath.row];
    cell.numberLb.text = [self.musicCategoryVM numberForRow:indexPath.row];
    [cell.iconIV.imageView sd_setImageWithURL:[self.musicCategoryVM iconURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"cell_bg_noData"]];
    cell.orderLb.text = @(indexPath.row + 1).stringValue;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicListViewController *vc = [[MusicListViewController alloc]initWithAlbumId:[self.musicCategoryVM albumIdForRow:indexPath.row]];
    vc.navigationItem.title = [self.musicCategoryVM titleForRow:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170 / 2;
}

@end
