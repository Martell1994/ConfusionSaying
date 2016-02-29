//
//  ZhiHuViewController.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuViewController.h"
#import "iCarousel.h"
#import "ZhiHuViewModel.h"
#import "ZhiHuViewCell.h"
#import "ZhiHuHtmlViewController.h"
//#import "NewsPhotoViewController.h"

@interface ZhiHuViewController () <iCarouselDelegate, iCarouselDataSource>
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZhiHuViewModel *zhVM;

@end

@implementation ZhiHuViewController{//添加成员变量,因为不需要懒加载,所以不需要是属性
    iCarousel *_ic;
    UIPageControl *_pageControl;
    UILabel *_titleLb;
    NSTimer *_timer;
}

/** 头部滚动视图 */
- (UIView *)headerView{
    [_timer invalidate];
    //如果当前没有头部视图,返回nil
    if(![self.zhVM isExistIndexPic]) return nil;
    
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
    _ic.scrollEnabled = self.zhVM.rowTopNum != 1;
    
    //添加底部视图
    UIView *botoomView = [UIView new];
    botoomView.backgroundColor = [UIColor clearColor];
    [headView addSubview:botoomView];
    [botoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
    _titleLb = [UILabel new];
    _titleLb.font = [UIFont systemFontOfSize:15 weight:1];
    _titleLb.textColor = [UIColor whiteColor];
    [botoomView addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
    }];
    _pageControl = [UIPageControl new];
    _pageControl.numberOfPages = self.zhVM.rowTopNum;
    [botoomView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(60);
        make.width.mas_greaterThanOrEqualTo(20);
        make.left.mas_equalTo(_titleLb.mas_right).mas_equalTo(10);
    }];
    _titleLb.text = [self.zhVM titleTopForRow:0];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = kRGBColor(200, 200, 242);
    
    if (self.zhVM.rowTopNum > 1) {
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
    return self.zhVM.rowTopNum;
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
    [imageView sd_setImageWithURL:[self.zhVM imageTopForRow:index] placeholderImage:[UIImage imageNamed:@"News_Avatar"]];
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
    _titleLb.text = [self.zhVM titleTopForRow:carousel.currentItemIndex];
    _pageControl.currentPage = carousel.currentItemIndex;
}
/** 滚动栏中被选中后触发 */
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    self.hidesBottomBarWhenPushed = YES;
    ZhiHuHtmlViewController *zhVC = [[ZhiHuHtmlViewController alloc]initWithStoryId:[self.zhVM story_idTopForRow:index]];
    [self.navigationController pushViewController:zhVC animated:YES];
}


- (ZhiHuViewModel *)zhVM{
    if (!_zhVM) {
        _zhVM = [[ZhiHuViewModel alloc]init];
    }
    return _zhVM;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日热闻";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.zhVM refreshDataCompleteHandle:^(NSError *error) {
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
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zhVM.rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhiHuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZhiHuCell"];
    if(!cell){
        cell = [[ZhiHuViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZhiHuCell"];
    }
    [cell.iv sd_setImageWithURL:[self.zhVM imageForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"News_Avatar"]];
    cell.titleLb.text = [self.zhVM titleForRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    ZhiHuHtmlViewController *zhVC = [[ZhiHuHtmlViewController alloc]initWithStoryId:[self.zhVM story_idForRow:indexPath.row]];
    zhVC.storyTitle = [self.zhVM titleForRow:indexPath.row];
    zhVC.storySource = @"今日热闻";
    zhVC.intoType = ZYIntoType;
    [self.navigationController pushViewController:zhVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
