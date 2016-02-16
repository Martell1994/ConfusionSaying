//
//  MyViewController.m
//  子曰
//
//  Created by Martell on 15/11/3.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MyViewController.h"
#import "MyReferenceViewController.h"
#import "SongViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ArticleViewController.h"
#import "FavorNewsViewController.h"
#import "MyHeaderCell.h"
#import "FavorCell.h"
#import "LogoutCell.h"
#import "Masonry.h"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *plistPath;
@property (nonatomic, assign) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@end

@implementation MyViewController

getPlistDic

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.loginOrNot) {
        NSIndexPath *accountIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[accountIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSIndexPath *songIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[songIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户设置";
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NaviHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.loginOrNot ? 4 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        return delegate.loginOrNot ? 2 : 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.loginOrNot) {
            if (indexPath.row == 0) {
                MyHeaderCell *cell = [[MyHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                return cell;
            } else {
                self.hidesBottomBarWhenPushed = YES;
                FavorCell *cell = [[FavorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                [cell.articleFBtn bk_addEventHandler:^(id sender) {
                    ArticleViewController *Avc = [ArticleViewController new];
                    [self.navigationController pushViewController:Avc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                } forControlEvents:UIControlEventTouchUpInside];
                [cell.newsFBtn bk_addEventHandler:^(id sender) {
                    FavorNewsViewController *FNvc = [FavorNewsViewController new];
                    [self.navigationController pushViewController:FNvc animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                } forControlEvents:UIControlEventTouchUpInside];
                [cell.songFBtn bk_addEventHandler:^(id sender) {
                    SongViewController *Svc = [[SongViewController alloc] init];
                    Svc.songType = favorSongType;
                    [self.navigationController pushViewController:Svc animated:YES];
                } forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        } else {
            LogoutCell *cell = [[LogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [cell.loginBtn bk_addEventHandler:^(id sender) {
                LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
                [self presentViewController:loginVC animated:YES completion:nil];
            } forControlEvents:UIControlEventTouchUpInside];
            [cell.registerBtn bk_addEventHandler:^(id sender) {
                RegisterViewController *registerVC = [storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
                [self presentViewController:registerVC animated:YES completion:nil];
            } forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"下载的音乐";
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            path = [path stringByAppendingPathComponent:@"songDownload.plist"];
            NSArray *arr = [NSArray arrayWithContentsOfFile:path];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld首",arr.count];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else if (indexPath.row == 1) {
            cell.textLabel.text  = @"流量状态下可收听音乐";
            UISwitch *listenSwt = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - 20, 10, 20, 30)];
            [cell addSubview:listenSwt];
        } else {
            cell.textLabel.text = @"流量状态下可下载音乐";
            UISwitch *downloadSwt = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - 20, 10, 20, 30)];
            [cell addSubview:downloadSwt];
        }
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"关于子曰";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *logout = [UIButton new];
        [cell addSubview:logout];
        [logout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
        [logout setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

//退出登录方法
- (void)logout {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.loginOrNot = 0;
    delegate.userId = 0;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.loginOrNot) {
            if (indexPath.row == 0) {
                MyReferenceViewController *vc = [[MyReferenceViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        SongViewController *vc = [[SongViewController alloc] init];
        vc.songType = downloadedSongType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AboutViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AboutZY"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.loginOrNot) {
            return indexPath.row ? 65 : 90;
        } else {
           return 170;
        }
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
@end
