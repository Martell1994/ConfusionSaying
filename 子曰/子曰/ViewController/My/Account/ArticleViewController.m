//
//  ArticleViewController.m
//  子曰
//
//  Created by Martell on 16/2/16.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ArticleViewController.h"
#import "ZhiHuHtmlViewController.h"
#import "ArticleCell.h"

@interface ArticleViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articleArr;
@end

@implementation ArticleViewController

- (NSMutableArray *)articleArr {
    if (!_articleArr) {
        _articleArr = [NSMutableArray new];
    }
    return  _articleArr;
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
    self.title = @"收藏的文章";
    BmobQuery *bmobQuery = [BmobQuery new];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *bql = [NSString stringWithFormat:@"select * from ZY_ArticleFavor where userId = '%@'",delegate.userId];
    [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        if (result) {
            for (BmobObject *obj in result.resultsAry) {
                [self.articleArr addObject:obj];
            }
            [self.tableView reloadData];
        }
    }];
    self.tableView.tableFooterView = [UIView new];
    [Factory addBackItemToVC:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    BmobObject *obj = self.articleArr[indexPath.row];
    cell.titleLb.text = [obj objectForKey:@"articleTitle"];
    cell.sourceLb.text = [obj objectForKey:@"articleSource"];
    NSString *dateStr = [obj objectForKey:@"createdAt"];
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    cell.timeLb.text = [NSString stringWithFormat:@"%@/%@/%@",[arr[0] substringFromIndex:2],arr[1],[arr[2] substringToIndex:2]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    ZhiHuHtmlViewController *zhVC = [[ZhiHuHtmlViewController alloc] initWithStoryId:[[self.articleArr[indexPath.row] objectForKey:@"articleId"] integerValue]];
    zhVC.intoType = WXSIntoType;
    [self.navigationController pushViewController:zhVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
