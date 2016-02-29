//
//  NotificationViewController.m
//  子曰
//
//  Created by Martell on 16/2/17.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotiDetailViewController.h"

@interface NotificationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notiArr;
@end

@implementation NotificationViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NaviHeight);
            make.left.right.bottom.mas_equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统通知";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [Factory addBackItemToVC:self];
    BmobQuery *bmobQ = [BmobQuery new];
    NSString *bql = @"select * from ZY_SystemNoti";
    self.notiArr = [NSMutableArray new];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [bmobQ queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        if (error) {
            NSLog(@"查询系统通知时失败,原因是%@",error);
        } else {
            if (result.resultsAry.count) {
                for (BmobObject *obj in result.resultsAry) {
                    [self.notiArr addObject:obj];
                }
            }
            [self.tableView reloadData];
            [progressHUD hide:YES];
        }
    }];
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notiArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.notiArr[indexPath.row] objectForKey:@"NotiTitle"];
    NSString *dateStr = [self.notiArr[indexPath.row] objectForKey:@"createdAt"];
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@月%@日",arr[1],[arr[2] substringToIndex:2]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NotiDetailViewController *NDvc = [NotiDetailViewController new];
    NDvc.title = cell.textLabel.text;
    NDvc.content = [self.notiArr[indexPath.row] objectForKey:@"NotiContent"];
    [self.navigationController pushViewController:NDvc animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
