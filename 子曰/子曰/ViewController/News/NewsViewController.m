//
//  NewsViewController.m
//  子曰
//
//  Created by Martell on 15/11/3.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "NewsViewController.h"
#import "iCarousel.h"
#import "NewsViewModel.h"
#import "NewsViewCell.h"
#import "NewsHtmlViewController.h"
#import "NewsPhotoViewController.h"

@interface NewsViewController ()<iCarouselDelegate, iCarouselDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NewsViewModel *newsVM;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewsViewController{//添加成员变量,因为不需要懒加载,所以不需要是属性
    iCarousel *_ic;
    UIPageControl *_pageControl;
    UILabel *_titleLb;
    NSTimer *_timer;
}

/** 头部滚动视图 */
- (UIView *)headerView{
    [_timer invalidate];
    //如果当前没有头部视图,返回nil
    if(![self.newsVM isExistIndexPic]) return nil;
    //头部视图origin无效,宽度无效,肯定是与table同宽
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kWindowW / 750 * 400)];
    //添加滚动栏
    _ic = [iCarousel new];
    [headView addSubview:_ic];
    [_ic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _ic.delegate = self;
    _ic.dataSource = self;
    _ic.pagingEnabled = YES;
    _ic.scrollSpeed = 1;
    //如果只有一张图,则不显示圆点
    _pageControl.hidesForSinglePage = YES;
    //如果只有一张图,则不可以滚动
    _ic.scrollEnabled = self.newsVM.rowTopNum != 1;
    
    //添加底部视图
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor clearColor];
    [headView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView *leftIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"night_photoset_list_cell_icon"]];
    
    [bottomView addSubview:leftIV];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(0);
    }];
    
    
    _titleLb = [UILabel new];
    _titleLb.font = [UIFont systemFontOfSize:15 weight:1];
    _titleLb.textColor = [UIColor whiteColor];
    [bottomView addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftIV.mas_right).mas_equalTo(5);
        make.centerY.mas_equalTo(0);
    }];
    _pageControl = [UIPageControl new];
    _pageControl.numberOfPages = self.newsVM.rowTopNum;
    [bottomView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(60);
        make.width.mas_greaterThanOrEqualTo(20);
        make.left.mas_equalTo(_titleLb.mas_right).mas_equalTo(10);
    }];
    _titleLb.text = [self.newsVM titleTopForRow:0];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = kRGBColor(200, 200, 242);
    
    if (self.newsVM.rowTopNum > 1) {
        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
            [_ic scrollToItemAtIndex:_ic.currentItemIndex + 1 animated:YES];
        } repeats:YES];
    }
    //小圆点 不能与用户交互
    _pageControl.userInteractionEnabled = NO;
    return headView;
}

#pragma mark - iCarousel Delegate
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.newsVM.rowTopNum;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowW / 750 * 400)];
        UIImageView *imageView = [UIImageView new];
        [view addSubview:imageView];
        imageView.tag = 100;
        imageView.contentMode = 2;
        view.clipsToBounds = YES;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    UIImageView *imageView = (UIImageView *)[view viewWithTag:100];
    [imageView sd_setImageWithURL:[self.newsVM imgsrcTopForRow:index] placeholderImage:[UIImage imageNamed:@"newsImgV_default"]];
    return view;
}

/** 允许循环滚动 */
-(CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

/** 监控当前滚到到第几个 */
-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    _titleLb.text = [self.newsVM titleTopForRow:carousel.currentItemIndex];
    _pageControl.currentPage = carousel.currentItemIndex;
}
/** 滚动栏中被选中后触发 */
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    self.tabBarController.tabBar.hidden = YES;
    if ([[self.newsVM tagTopForRow:index] isEqualToString:@"photoset"]) {
        NewsPhotoViewController *npVC = [[NewsPhotoViewController alloc] initWithUrlString:[self.newsVM urlTopForRow:index] withNewsTitle:[self.newsVM titleTopForRow:index]];
        [self.navigationController pushViewController:npVC animated:YES];
    }else{
        NewsHtmlViewController *hlVC = [[NewsHtmlViewController alloc] initWithDocId:[self.newsVM docidTopForRow:index] withNewsImage:[self.newsVM imgsrcTopForRow:index]];
        hlVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hlVC animated:YES];
    }
}

- (NewsViewModel *)newsVM{
    if (!_newsVM) {
        _newsVM = [[NewsViewModel alloc]init];
    }
    return _newsVM;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"要闻先知";
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_bg"]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.newsVM refreshDataCompleteHandle:^(NSError *error) {
            if (error) {
                [self showErrorMsg:error.localizedDescription];
            }else{
                [self.tableView reloadData];
                self.tableView.tableHeaderView = [self headerView];
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.newsVM getMoreDataCompleteHandle:^(NSError *error) {
            if(error){
                [self showErrorMsg:error.localizedDescription];
            }else{
                [self.tableView reloadData];
                if([self.newsVM isHasMore]){
                    self.tableView.tableHeaderView = [self headerView];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsVM.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    if(!cell){
        cell = [[NewsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell.imgIV sd_setImageWithURL:[NSURL URLWithString:[self.newsVM imgsrcForRow:indexPath.row]] placeholderImage:[UIImage imageNamed:@"NewsCell_default"]];
    cell.titleLb.text = [self.newsVM titleForRow:indexPath.row];
    cell.digestLb.text = [self.newsVM digestForRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    NewsHtmlViewController *nhVC = [[NewsHtmlViewController alloc] initWithDocId:[self.newsVM docidForRow:indexPath.row] withNewsImage:[NSURL URLWithString:[self.newsVM imgsrcForRow:indexPath.row]]];
    nhVC.docTitle = [self.newsVM titleForRow:indexPath.row];
    nhVC.imgStr = [self.newsVM imgsrcForRow:indexPath.row];
    [self.navigationController pushViewController:nhVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
