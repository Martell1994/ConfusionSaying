//
//  ZhiHuCateDetailViewController.m
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuCateDetailViewController.h"
#import "ZhiHuViewCell.h"
#import "ZhiHuCateDetailViewModel.h"
#import "ZhiHuHtmlViewController.h"

@interface ZhiHuCateDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZhiHuCateDetailViewModel *zhCDVM;
@property (nonatomic, strong) UIImageView *headView;
@end

@implementation ZhiHuCateDetailViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.bottom.right.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (instancetype)initWithcateId:(NSInteger)cateId{
    if (self = [super init]) {
        self.cateId = cateId;
    }
    return self;
}

- (ZhiHuCateDetailViewModel *)zhCDVM{
    if (!_zhCDVM) {
        _zhCDVM = [[ZhiHuCateDetailViewModel alloc]init];
    }
    return _zhCDVM;
}

- (UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 128)];
    }
    return _headView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    NSLog(@"x");
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"xx");
    //设置导航栏为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_transparent"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)]){
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_white"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Factory addBackItemToVC:self];
    [self.zhCDVM refreshDataByCateId:self.cateId CompleteHandle:^(NSError *error) {
        if (error) {
            [self showErrorMsg:error.localizedDescription];
        }else{
            [self.tableView reloadData];
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.view addSubview:self.headView];
        [self.headView sd_setImageWithURL:[self.zhCDVM imageUrl] placeholderImage:[UIImage imageNamed:@"News_Avatar"]];
        self.title = [self.zhCDVM name];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:1],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY <= 0 && offSetY >= -64) {
        self.headView.frame = CGRectMake(0, -64 - offSetY, kWindowW, 128);
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zhCDVM.rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhiHuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZhiHuCateDetailCell"];
    if(!cell){
        cell = [[ZhiHuViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZhiHuCateDetailCell"];
    }
    cell.titleLb.text = [self.zhCDVM titleForRow:indexPath.row];
    if ([self.zhCDVM imageForRow:indexPath.row]) {
        [cell.iv sd_setImageWithURL:[self.zhCDVM imageForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"News_Avatar"]];
    }else{
        [cell.iv removeFromSuperview];
        [cell.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    ZhiHuHtmlViewController *zhVC = [[ZhiHuHtmlViewController alloc]initWithStoryId:[self.zhCDVM storyIdForRow:indexPath.row]];
    zhVC.storyTitle = [self.zhCDVM titleForRow:indexPath.row];
    zhVC.storySource = self.title;
    zhVC.intoType = ZYIntoType;
    [self.navigationController pushViewController:zhVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
