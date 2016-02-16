//
//  FavorNewsViewController.m
//  子曰
//
//  Created by Martell on 16/2/16.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "FavorNewsViewController.h"
#import "NewsHtmlViewController.h"
#import "NewsCell.h"

@interface FavorNewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsArr;
@end

@implementation FavorNewsViewController

- (NSMutableArray *)newsArr {
    if (!_newsArr) {
        _newsArr = [NSMutableArray new];
    }
    return  _newsArr;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏的新闻";
    BmobQuery *bmobQuery = [BmobQuery new];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *bql = [NSString stringWithFormat:@"select * from ZY_NewsFavor where userId = '%@'",delegate.userId];
    [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        if (result) {
            for (BmobObject *obj in result.resultsAry) {
                [self.newsArr addObject:obj];
            }
            [self.tableView reloadData];
        }
    }];
    self.tableView.tableFooterView = [UIView new];
    [Factory addBackItemToVC:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    BmobObject *obj = self.newsArr[indexPath.row];
    cell.titleLb.text = [obj objectForKey:@"newsTitle"];
    NSString *dateStr = [obj objectForKey:@"createdAt"];
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    cell.timeLb.text = [NSString stringWithFormat:@"%@/%@/%@",[arr[0] substringFromIndex:2],arr[1],[arr[2] substringToIndex:2]];
    [cell.headImgV sd_setImageWithURL:[obj objectForKey:@"newsImage"] placeholderImage:[UIImage imageNamed:@"loading"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    NewsHtmlViewController *zhVC = [[NewsHtmlViewController alloc] initWithDocId:[self.newsArr[indexPath.row] objectForKey:@"newsId"]];
    [self.navigationController pushViewController:zhVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
