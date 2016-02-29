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

@interface ArticleViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *articleArr;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, assign) BOOL isPush;

@end

@implementation ArticleViewController

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _searchController;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar setHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏的文章";
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"article_bg"]];
    self.tableView.tableFooterView = [UIView new];
    [Factory addBackItemToVC:self];
    self.articleArr = [NSMutableArray new];
    self.searchList = [NSMutableArray new];
    [self showProgressOn:self.view];
    BmobQuery *bmobQuery = [BmobQuery new];
    NSString *bql = [NSString stringWithFormat:@"select * from ZY_ArticleFavor where userId = '%@'",ZYDelegate.userId];
    [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        if (result) {
            [self hideProgressOn:self.view];
            for (BmobObject *obj in result.resultsAry) {
                [self.articleArr addObject:obj];
            }
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchList.count;
    } else {
        return self.articleArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    BmobObject *obj = nil;
    if (self.searchController.active) {
        obj = self.searchList[indexPath.row];
    } else {
        obj = self.articleArr[indexPath.row];
    }
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
    BmobObject *obj = nil;
    if (self.searchController.active) {
        obj = self.searchList[indexPath.row];
    } else {
        obj = self.articleArr[indexPath.row];
    }
    ZhiHuHtmlViewController *zhVC = [[ZhiHuHtmlViewController alloc] initWithStoryId:[[obj objectForKey:@"articleId"] integerValue]];
    zhVC.intoType = WXSIntoType;
    zhVC.storyTitle = [obj objectForKey:@"articleTitle"];
    zhVC.storySource = [obj objectForKey:@"articleSource"];
    [self.navigationController pushViewController:zhVC animated:YES];
    self.isPush = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - 实现UISearchResultsUpdating的required的必须方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%d",self.searchController.active);
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    for (BmobObject *obj in _articleArr) {
        if ([[obj objectForKey:@"articleTitle"] containsString:[self.searchController.searchBar text]]) {
            [self.searchList addObject:obj];
        }
    }
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark - 取消收藏
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消收藏";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BmobObject *deleteObj = self.articleArr[indexPath.row];
        [deleteObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [self.articleArr removeObject:deleteObj];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (error) {
                NSLog(@"取消收藏文章时失败，原因为%@",error);
            } else{
                NSLog(@"取消收藏文章时失败，原因未知");
            }
        }];
    }
}

//- (void)dealloc {
//    NSLog(@"dealloc");
//    self.searchController.searchBar.showsCancelButton = NO;
//}

@end
