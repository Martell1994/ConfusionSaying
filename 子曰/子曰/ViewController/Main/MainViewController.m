//
//  MainViewController.m
//  子曰
//
//  Created by Martell on 15/11/3.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherViewModel.h"
#import "MusicCategoryViewModel.h"
#import "MusicListViewController.h"
#import "ZhiHuCategoryViewModel.h"
#import "ZhiHuCateDetailViewController.h"
#import "ZhiHuViewController.h"
#import "ZhiHuViewModel.h"
#import "ZhiHuHtmlViewController.h"
#import "NewsHtmlViewController.h"
#import "PlayViewController.h"

#import "PlayView.h"
#import "NewsViewModel.h"
#import "ArcView.h"
#import <CoreLocation/CoreLocation.h>

@interface MainViewController ()<CLLocationManagerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *weatherView;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *weatherLabel;
@property (nonatomic, strong) UILabel *pollutionLabel;
@property (nonatomic, strong) UILabel *wordLabel;

@property (nonatomic, strong) UIScrollView *zhMenuSV;
@property (nonatomic, strong) NSArray *zhLogoArr;
@property (nonatomic, strong) NSArray *zhNameArr;

@property (nonatomic, strong) UIView *hotNewsView;
@property (nonatomic, strong) ZhiHuViewModel *zhVM;

@property (nonatomic, strong) UIView *musicView;
@property (nonatomic, strong) MusicCategoryViewModel *musicCategoryVM;

@property (nonatomic, strong) UIView *newsView;
@property (nonatomic, strong) NewsViewModel *newsVM;

@property (nonatomic, strong) ArcView *arcView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,strong) WeatherViewModel *weatherVM;
@property (nonatomic, strong) ZhiHuCategoryViewModel *zhCateVM;
@end

@implementation MainViewController

#define weatherViewHeight 100
#define margin 8
#define menuHeight 95
#define menuCenterMargin 20
#define menuLogoWidth 56
#define menuNameHeight 20
#define menuNamelogoMargin 6
#define hnTopMargin 5
#define hnMargin 12
#define hnMoreLbWidth 60
#define hnNameAndMoreHeight 20
#define hnHeight 180
#define musicHeight 185
#define newsHeight 185
#define viewAndViewMargin 5


#pragma mark - lazyLoad
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kWindowW, weatherViewHeight + menuHeight + viewAndViewMargin + hnHeight + viewAndViewMargin + musicHeight + viewAndViewMargin + newsHeight + 10);
        _scrollView.frame = CGRectMake(0, 64, kWindowW, kWindowH - 64 - 40);
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}

- (UIView *)weatherView{
    if (!_weatherView) {
        _weatherView = [[UIView alloc]init];
        _weatherView.frame = CGRectMake(0, 0, kWindowW, weatherViewHeight);
        
        [self.scrollView addSubview:_weatherView];
        _weatherView.backgroundColor = kRGBColor(236, 244, 239);
        
        //先触发懒加载
        NSDictionary *settingDic = [NSDictionary dictionaryWithContentsOfFile:[DirectoriesPath stringByAppendingPathComponent:@"setting.plist"]];
        self.tempLabel.text = settingDic[@"temperature"];
        self.weatherLabel.text = settingDic[@"weather"];
        self.pollutionLabel.text = settingDic[@"pollution"];
        self.wordLabel.text = @"子曰：不要仰望别人，自己亦是风景。";
        
        UIButton *locationBtn = [[UIButton alloc]init];
        locationBtn.frame = CGRectMake(20, 8, 16, 24);
        [_weatherView addSubview:locationBtn];
        [locationBtn setImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
        [locationBtn bk_addEventHandler:^(id sender) {
            [self startLocationServices];
            self.cityLabel.text = @"定位中";
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _weatherView;
}

- (UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.font = [UIFont systemFontOfSize:18];
        _cityLabel.frame = CGRectMake(42, 14, 128, 21);
        [_weatherView addSubview:_cityLabel];
    }
    return _cityLabel;
}
- (UILabel *)tempLabel{
    if (!_tempLabel) {
        _tempLabel = [[UILabel alloc]init];
        _tempLabel.font = [UIFont systemFontOfSize:16];
        _tempLabel.frame = CGRectMake(40, 43, 53, 21);
        [_weatherView addSubview:_tempLabel];
    }
    return _tempLabel;
}

- (UILabel *)weatherLabel{
    if (!_weatherLabel) {
        _weatherLabel = [[UILabel alloc]init];
        _weatherLabel.font = [UIFont systemFontOfSize:15];
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.frame = CGRectMake(kWindowW / 2 - 80, 42, 83, 21);
        [_weatherView addSubview:_weatherLabel];
    }
    return _weatherLabel;
}

- (UILabel *)pollutionLabel{
    if (!_pollutionLabel) {
        _pollutionLabel = [[UILabel alloc]init];
        _pollutionLabel.font = [UIFont systemFontOfSize:15];
        _pollutionLabel.frame = CGRectMake(kWindowW - 145 - 10, 43, 145, 21);
        [_weatherView addSubview:_pollutionLabel];
    }
    return _pollutionLabel;
}

- (UILabel *)wordLabel{
    if (!_wordLabel) {
        _wordLabel = [[UILabel alloc]init];
        _wordLabel.font = [UIFont systemFontOfSize:15];
        _wordLabel.textColor = kRGBColor(111, 113, 121);
        _wordLabel.frame = CGRectMake(40, 71, 261, 21);
        [_weatherView addSubview:_wordLabel];
    }
    return _wordLabel;
}

- (UIScrollView *)zhMenuSV{
    if (!_zhMenuSV) {
        _zhMenuSV = [[UIScrollView alloc]init];
        _zhMenuSV.frame = CGRectMake(0, weatherViewHeight, kWindowW, menuHeight);
        _zhMenuSV.contentSize = CGSizeMake(margin + margin + 12 * (menuCenterMargin + menuLogoWidth), self.zhMenuSV.frame.size.height);
        _zhMenuSV.alwaysBounceHorizontal = YES;
        _zhMenuSV.showsHorizontalScrollIndicator = NO;
        _zhMenuSV.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_zhMenuSV];
    }
    return _zhMenuSV;
}

- (UIView *)hotNewsView{
    if (!_hotNewsView) {
        _hotNewsView = [[UIView alloc]init];
        _hotNewsView.backgroundColor = [UIColor whiteColor];
        _hotNewsView.frame = CGRectMake(0, weatherViewHeight + menuHeight + viewAndViewMargin , kWindowW, hnHeight);
        [self.scrollView addSubview:_hotNewsView];
    }
    return _hotNewsView;
}

- (WeatherViewModel *)weatherVM{
    if (!_weatherVM) {
        _weatherVM = [WeatherViewModel new];
    }
    return _weatherVM;
}

- (NSArray *)zhLogoArr{
    if (!_zhLogoArr) {
        _zhLogoArr = @[@"rcxl",@"tjrb",@"dyrb",@"bxwl",@"sjrb",@"gsrb",@"cjrb",@"wlaq",@"ksyx",@"yyrb",@"dmrb",@"tyrb"];
    }
    return _zhLogoArr;
}

- (NSArray *)zhNameArr{
    if (!_zhNameArr) {
        _zhNameArr = @[@"日常心理",@"推荐日报",@"电影日报",@"不许无聊",@"设计日报",@"公司日报",@"财经日报",@"网络安全",@"开始游戏",@"音乐日报",@"动漫日报",@"体育日报"];
    }
    return _zhNameArr;
}

- (ZhiHuViewModel *)zhVM{
    if (!_zhVM) {
        _zhVM = [[ZhiHuViewModel alloc]init];
    }
    return _zhVM;
}

- (ZhiHuCategoryViewModel *)zhCateVM{
    if (!_zhCateVM) {
        _zhCateVM = [[ZhiHuCategoryViewModel alloc]init];
    }
    return _zhCateVM;
}

- (UIView *)musicView{
    if (!_musicView) {
        _musicView = [[UIView alloc]init];
        _musicView.backgroundColor = [UIColor whiteColor];
        _musicView.frame = CGRectMake(0, weatherViewHeight + menuHeight + viewAndViewMargin + hnHeight + viewAndViewMargin, kWindowW, musicHeight);
        [self.scrollView addSubview:_musicView];
    }
    return _musicView;
}

- (MusicCategoryViewModel *)musicCategoryVM {
    if (!_musicCategoryVM) {
        _musicCategoryVM = [MusicCategoryViewModel new];
    }
    return _musicCategoryVM;
}

- (UIView *)newsView{
    if (!_newsView) {
        _newsView = [[UIView alloc]init];
        _newsView.backgroundColor = [UIColor whiteColor];
        _newsView.frame = CGRectMake(0, weatherViewHeight + menuHeight + viewAndViewMargin + hnHeight + viewAndViewMargin + newsHeight + viewAndViewMargin, kWindowW, musicHeight);
        [self.scrollView addSubview:_newsView];
    }
    return _newsView;
}

- (NewsViewModel *)newsVM{
    if (!_newsVM) {
        _newsVM = [[NewsViewModel alloc]init];
    }
    return _newsVM;
}

- (ArcView *)arcView{
    if (!_arcView) {
        _arcView = [[ArcView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, weatherViewHeight + menuHeight)];
        _arcView.backgroundColor = kRGBColor(220, 220, 220);

        [self.view addSubview:_arcView];
    }
    return _arcView;
}

#pragma mark - UIScrollView
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offSetY = scrollView.contentOffset.y;
////    if (-offSetY > 0 && -offSetY < 32) {
////        self.arcView.iv1.image = [UIImage imageNamed:@"position"];
////    }
//    
//    if (-offSetY <= 64 && -offSetY >= 32) {
////文字
//        self.arcView.lb.text = @"下拉刷新😁";
//        self.arcView.lb.alpha = (-offSetY - 32) / 32.0;
////箭头旋转
//        self.arcView.iv1.image = [UIImage imageNamed:@"arrow"];
//        self.arcView.iv1.alpha = (-offSetY - 32) / 32.0;
//        //计算停止时的旋转角度
//        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * (-offSetY - 32) / 32.0);
//        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.arcView.iv1.transform = transform;
//        } completion:^(BOOL finished) {
//        }];
//        
////圆弧进度条
////        self.arcView.progress = (-offSetY - 32) / 32.0;
////        [self.arcView setNeedsDisplay];
//    }
//    if (-offSetY > 64) {//开始刷新数据
//        self.arcView.lb.text = @"释放刷新😫";
////        self.arcView.progress = 1;
////        [self.arcView setNeedsDisplay];
//        
//        CGPoint offset = scrollView.contentOffset;
//        NSLog(@"%f",offset.y);
////        [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
////        让scrollview停在64的位置不能下拉
////        (scrollView.contentOffset.y > 0) ? offset.y-- : offset.y++;
////        [scrollView setContentOffset:CGPointMake(0, -64) animated:NO];
//    }
//}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    CGPoint p = (CGPoint)targetContentOffset;
//    NSLog(@"end:%f",velocity.y);
//}
#pragma mark - zhihuMenu

- (void)addEventMenuSV{
    for (NSInteger i = self.zhNameArr.count - 1; i >= 0 ; i--) {
        UIButton *logoBtn = [[UIButton alloc]init];
        logoBtn.tag = i;
        logoBtn.frame = CGRectMake(margin + (self.zhNameArr.count - 1 - i) * (menuLogoWidth + menuCenterMargin), margin, menuLogoWidth, menuLogoWidth);
        logoBtn.clipsToBounds = YES;
        logoBtn.layer.cornerRadius = logoBtn.frame.size.width / 2;
        [self.zhMenuSV addSubview:logoBtn];
        [logoBtn bk_addEventHandler:^(UIButton *sender) {
            self.hidesBottomBarWhenPushed = YES;
            ZhiHuCateDetailViewController *zhVC = [[ZhiHuCateDetailViewController alloc]initWithcateId:[self.zhCateVM cateIdForRow:sender.tag]];
            [self.navigationController pushViewController:zhVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showMenuSV{
    for (NSInteger i = self.zhNameArr.count - 1; i >= 0 ; i--) {
        UIImageView *logoIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.zhLogoArr[i]]];
        logoIV.frame = CGRectMake(margin + (self.zhNameArr.count - 1 - i) * (menuLogoWidth + menuCenterMargin), margin, menuLogoWidth, menuLogoWidth);
        logoIV.clipsToBounds = YES;
        logoIV.layer.cornerRadius = logoIV.frame.size.width / 2;
        [self.zhMenuSV addSubview:logoIV];
        //  创建需要的毛玻璃特效类型
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃view 视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        effectView.frame = logoIV.bounds;
        [logoIV addSubview:effectView];
        //设置模糊透明度
        effectView.alpha = 0.5;

        UILabel *nameLb = [[UILabel alloc]init];
        nameLb.frame = CGRectMake(logoIV.frame.origin.x, logoIV.frame.origin.y + logoIV.frame.size.height + menuNamelogoMargin, logoIV.frame.size.width, menuNameHeight);
        nameLb.textAlignment = NSTextAlignmentCenter;
        nameLb.font = [UIFont systemFontOfSize:12];
        nameLb.text = self.zhNameArr[i];
        [self.zhMenuSV addSubview:nameLb];
    }
}

#pragma mark - todayHotNews

- (void)showTodayHotNewsContent{
    for (int i = 0; i < 3; i++) {
        UIImageView *rankIV = [[UIImageView alloc]init];
        [rankIV sd_setImageWithURL:[self.zhVM imageTopForRow:i] placeholderImage:[UIImage imageNamed:@"loading"]];
        rankIV.frame = CGRectMake(hnMargin + i * ((kWindowW - 4 * hnMargin) / 3 + hnMargin), hnNameAndMoreHeight + hnTopMargin + 5, (kWindowW - 4 * hnMargin) / 3, (kWindowW - 4 * hnMargin) / 3);
        [self.hotNewsView addSubview:rankIV];
        UIButton *rankBtn = [[UIButton alloc]init];
        rankBtn.tag = i;
        rankBtn.frame = rankIV.frame;
        [self.hotNewsView addSubview:rankBtn];
        [rankBtn bk_addEventHandler:^(UIButton *sender) {
            self.hidesBottomBarWhenPushed = YES;
            ZhiHuHtmlViewController *zhVC = [[ZhiHuHtmlViewController alloc]initWithStoryId:[self.zhVM story_idTopForRow:sender.tag]];
            [self.navigationController pushViewController:zhVC animated:YES];
            zhVC.storyTitle = [self.zhVM titleTopForRow:i];
            zhVC.storySource = @"今日热闻";
            self.hidesBottomBarWhenPushed = NO;
        } forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.text = [self.zhVM titleTopForRow:i];
        titleLb.font = [UIFont systemFontOfSize:12];
        titleLb.frame = CGRectMake(rankIV.frame.origin.x, rankIV.frame.origin.y + rankIV.frame.size.height, rankIV.frame.size.width, 32);
        titleLb.numberOfLines = 2;
        [self.hotNewsView addSubview:titleLb];
    }
}

- (void)showTodayHotNewsTop{
    UIImageView *triangleImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle"]];
    triangleImgV.frame = CGRectMake(hnMargin, hnTopMargin + 3, hnNameAndMoreHeight * 0.55, hnNameAndMoreHeight - 6);
    [self.hotNewsView addSubview:triangleImgV];
    UILabel *hnNameLb = [[UILabel alloc]init];
    hnNameLb.frame = CGRectMake(hnMargin + hnNameAndMoreHeight * 0.8, hnTopMargin, kWindowW - hnMoreLbWidth, hnNameAndMoreHeight);
    hnNameLb.font = [UIFont systemFontOfSize:14];
    hnNameLb.text = @"今日热闻";
    [self.hotNewsView addSubview:hnNameLb];
    
    UILabel *hnMoreLb = [[UILabel alloc]init];
    hnMoreLb.frame = CGRectMake(kWindowW - hnMargin - hnMoreLbWidth, hnTopMargin, hnMoreLbWidth, hnNameAndMoreHeight);
    hnMoreLb.textColor = [UIColor grayColor];
    hnMoreLb.textAlignment = NSTextAlignmentRight;
    hnMoreLb.font = [UIFont systemFontOfSize:12];
    hnMoreLb.text = @"更多>";
    [self.hotNewsView addSubview:hnMoreLb];
    
    UIButton *moreBtn = [[UIButton alloc]init];
    moreBtn.frame = CGRectMake(0, 0, self.hotNewsView.frame.size.width, hnNameAndMoreHeight);
    [self.hotNewsView addSubview:moreBtn];
    [moreBtn bk_addEventHandler:^(id sender) {
        self.hidesBottomBarWhenPushed = YES;
        ZhiHuViewController *zhVC = [[ZhiHuViewController alloc]init];
        [self.navigationController pushViewController:zhVC animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
    } forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - musicView
- (void)showMusicViewTop{
    UIImageView *triangleImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle"]];
    triangleImgV.frame = CGRectMake(hnMargin, hnTopMargin + 3, hnNameAndMoreHeight * 0.55, hnNameAndMoreHeight - 6);
    [self.musicView addSubview:triangleImgV];
    UILabel *musicNameLb = [[UILabel alloc]init];
    musicNameLb.frame = CGRectMake(hnMargin + hnNameAndMoreHeight * 0.8, hnTopMargin, kWindowW - hnMoreLbWidth, hnNameAndMoreHeight);
    musicNameLb.font = [UIFont systemFontOfSize:14];
    musicNameLb.text = @"音乐推荐";
    [self.musicView addSubview:musicNameLb];
}

- (void)showMusicViewContent{
    for (int i = 0; i < 3; i++) {
        UIImageView *rankIV = [[UIImageView alloc]init];
        [rankIV sd_setImageWithURL:[self.musicCategoryVM iconURLForRow:i] placeholderImage:[UIImage imageNamed:@"cell_bg_noData"]];
        rankIV.frame = CGRectMake(hnMargin + i * ((kWindowW - 4 * hnMargin) / 3 + hnMargin), hnNameAndMoreHeight + hnTopMargin * 2, (kWindowW - 4 * hnMargin) / 3, (kWindowW - 4 * hnMargin) / 3);
        [self.musicView addSubview:rankIV];
        
        UIButton *rankBtn = [[UIButton alloc]init];
        rankBtn.tag = i;
        rankBtn.frame = rankIV.frame;
        [self.musicView addSubview:rankBtn];
        [rankBtn bk_addEventHandler:^(UIButton *sender) {
            self.hidesBottomBarWhenPushed = YES;
            MusicListViewController *mlVC = [[MusicListViewController alloc]initWithAlbumId:[self.musicCategoryVM albumIdForRow:sender.tag]];
            mlVC.navigationItem.title = [self.musicCategoryVM titleForRow:sender.tag];
            [self.navigationController pushViewController:mlVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.text = [self.musicCategoryVM titleForRow:i];
        titleLb.font = [UIFont systemFontOfSize:12];
        titleLb.frame = CGRectMake(rankIV.frame.origin.x, rankIV.frame.origin.y + rankIV.frame.size.height, rankIV.frame.size.width, 20);
        titleLb.numberOfLines = 1;
        [self.musicView addSubview:titleLb];
        
        UILabel *descLb = [[UILabel alloc]init];
        descLb.text = [self.musicCategoryVM descForRow:i];
        descLb.textColor = [UIColor grayColor];
        descLb.font = [UIFont systemFontOfSize:12];
        descLb.frame = CGRectMake(titleLb.frame.origin.x, titleLb.frame.origin.y + titleLb.frame.size.height, titleLb.frame.size.width, 20);
        [self.musicView addSubview:descLb];
        
    }
}

#pragma mark - newsView
- (void)showNewsViewTop{
    UIImageView *triangleImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle"]];
    triangleImgV.frame = CGRectMake(hnMargin, hnTopMargin + 3, hnNameAndMoreHeight * 0.55, hnNameAndMoreHeight - 6);
    [self.newsView addSubview:triangleImgV];
    UILabel *newsNameLb = [[UILabel alloc]init];
    newsNameLb.frame = CGRectMake(hnMargin + hnNameAndMoreHeight * 0.8, hnTopMargin, kWindowW - hnMoreLbWidth, hnNameAndMoreHeight);
    newsNameLb.font = [UIFont systemFontOfSize:14];
    newsNameLb.text = @"新闻速递";
    [self.newsView addSubview:newsNameLb];
}

- (void)showNewsViewContent{
    for (int i = 0; i < 3; i++) {
        UIImageView *rankIV = [[UIImageView alloc]init];
        [rankIV sd_setImageWithURL:[NSURL URLWithString:[self.newsVM imgsrcForRow:i]] placeholderImage:[UIImage imageNamed:@"NewsCell_default"]];
        rankIV.frame = CGRectMake(hnMargin + i * ((kWindowW - 4 * hnMargin) / 3 + hnMargin), hnNameAndMoreHeight + hnTopMargin * 2, (kWindowW - 4 * hnMargin) / 3, (kWindowW - 4 * hnMargin) / 3);
        [self.newsView addSubview:rankIV];
        
        UIButton *rankBtn = [[UIButton alloc]init];
        rankBtn.tag = i;
        rankBtn.frame = rankIV.frame;
        [self.newsView addSubview:rankBtn];
        [rankBtn bk_addEventHandler:^(UIButton *sender) {
            self.hidesBottomBarWhenPushed = YES;
            NewsHtmlViewController *nhVC = [[NewsHtmlViewController alloc]initWithDocId:[self.newsVM docidForRow:i]];
            nhVC.navigationItem.title = [self.newsVM titleForRow:sender.tag];
            [self.navigationController pushViewController:nhVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.text = [self.newsVM titleForRow:i];
        titleLb.font = [UIFont systemFontOfSize:12];
        titleLb.frame = CGRectMake(rankIV.frame.origin.x, rankIV.frame.origin.y + rankIV.frame.size.height, rankIV.frame.size.width, 40);
        titleLb.numberOfLines = 2;
        [self.newsView addSubview:titleLb];
    }
}


#pragma mark - viewFunc

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:1],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:[PlayViewButton standardPlayViewBtn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(220, 220, 220);
    self.arcView.alpha = 1;
     //为了触发weatherView的懒加载
    self.weatherView.alpha = 1;
    [[PlayViewButton standardPlayViewBtn] bk_addEventHandler:^(id sender) {
        if ([PlayView sharedInstance].musicListType == noneMusicType) {
            [self showMsg:@"暂无歌曲哟，快去添加吧~"];
        } else {
            PlayViewController *vc = [PlayViewController new];
            [self presentViewController:vc animated:YES completion:nil];
        }
    } forControlEvents:UIControlEventTouchDownRepeat];
    
    self.navigationItem.title = @"今日精选";
    NSDictionary *settingDic = [NSDictionary dictionaryWithContentsOfFile:[DirectoriesPath stringByAppendingPathComponent:@"setting.plist"]];
    self.cityLabel.text = settingDic[@"city"];
    if ([settingDic[@"city"] isEqualToString:@"未定位"]) {
        [self startLocationServices];
        [self refreshWeatherInfo:@"杭州市"];
    } else {
        [self refreshWeatherInfo:settingDic[@"city"]];
    }
    [self showMenuSV];
    [self.zhCateVM refreshDataCompleteHandle:^(NSError *error) {
        if (error) {
            [self showErrorMsg:error.localizedDescription];
        }else{
            [self addEventMenuSV];
        }
    }];
    
    [self showTodayHotNewsTop];
    [self.zhVM refreshDataCompleteHandle:^(NSError *error) {
        if (error) {
            [self showErrorMsg:error.localizedDescription];
        }else{
            [self showTodayHotNewsContent];
        }
    }];
    [self showMusicViewTop];
    [self.musicCategoryVM refreshDataCompletionHandle:^(NSError *error) {
        if (error) {
            [self showErrorMsg:error.localizedDescription];
        } else {
            [self showMusicViewContent];
        }
    }];
    
    [self showNewsViewTop];
    [self.newsVM refreshDataCompleteHandle:^(NSError *error) {
        if (error) {
            [self showErrorMsg:error.localizedDescription];
        }else{
            [self showNewsViewContent];
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}
#pragma mark - location
//开启定位服务
- (void)startLocationServices {
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSMutableDictionary *info = [[[NSMutableDictionary alloc] initWithContentsOfFile:[DirectoriesPath stringByAppendingPathComponent:@"setting.plist"]] mutableCopy];
        NSString *city = placemarks.firstObject.locality;
        if (city) {
            self.cityLabel.text = city;
            [info setValue:self.cityLabel.text forKey:@"city"];
            [info writeToFile:[DirectoriesPath stringByAppendingPathComponent:@"setting.plist"] atomically:YES];
            [self refreshWeatherInfo:city];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
    self.cityLabel.text = @"定位失败";
}

//刷新首页上方天气状况
- (void)refreshWeatherInfo:(NSString *)city{
    [self.weatherVM refreshDataByCity:city CompleteHandle:^(NSError *error) {
        self.tempLabel.text = [self.weatherVM realtimeTemperature];
        self.weatherLabel.text = [self.weatherVM realtimeInfo];
        self.pollutionLabel.text = [self.weatherVM weatherQuality];
        //存入plist文件中
        NSDictionary *settingDic = [NSDictionary dictionaryWithContentsOfFile:[DirectoriesPath stringByAppendingPathComponent:@"setting.plist"]];
        [settingDic setValue:self.tempLabel.text forKey:@"temperature"];
        [settingDic setValue:self.weatherLabel.text forKey:@"weather"];
        [settingDic setValue:self.pollutionLabel.text forKey:@"pollution"];
        [settingDic writeToFile:[DirectoriesPath stringByAppendingPathComponent:@"setting.plist"] atomically:YES];
    }];
}
@end
