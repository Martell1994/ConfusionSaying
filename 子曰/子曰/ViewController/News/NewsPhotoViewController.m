//
//  NewsPhotoViewController.m
//  子曰
//
//  Created by Martell on 16/1/24.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsPhotoViewController.h"
#import "NewsPhotoViewModel.h"
#import "NewsPhotoView.h"

#define margin 10
#define noteTopViewHeight 20
#define noteWidth 15
#define indexLbWidth 15

@interface NewsPhotoViewController () <UIScrollViewDelegate, UMSocialUIDelegate>
@property (nonatomic, strong) NewsPhotoViewModel *npVM;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *noteArr;
@property (nonatomic, strong) NewsPhotoView *npView;

@property (nonatomic,strong) NSString *urlString;
@property (nonatomic, strong) NSString *newsTitle;
@end

@implementation NewsPhotoViewController

- (NewsPhotoView *)npView{
    if (!_npView) {
        _npView = [[NewsPhotoView alloc]initWithNote:[self.npVM noteForRow:0] InView:self.view];
    }
    return _npView;
}

- (NSMutableArray *)imgArr{
    if (!_imgArr) {
        _imgArr = [NSMutableArray new];
    }
    return _imgArr;
}

- (NSMutableArray *)noteArr{
    if (!_noteArr) {
        _noteArr = [NSMutableArray new];
    }
    return _noteArr;
}

- (NewsPhotoViewModel *)npVM{
    if (!_npVM) {
        _npVM = [[NewsPhotoViewModel alloc]init];
    }
    return _npVM;
}

- (instancetype)initWithUrlString:(NSString *)urlString withNewsTitle:(NSString *)newsTitle{
    if (self = [super init]) {
        self.urlString = urlString;
        self.newsTitle = newsTitle;
    }
    return self;
}

- (void)initView{
    self.npView.imgSV.delegate = self;
    self.npView.imgSV.contentSize = CGSizeMake(self.npVM.rowNum * kWindowW, kWindowH / 3 + 40);
    for (int i = 0; i < self.npVM.rowNum; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i * kWindowW, 0, kWindowW, kWindowH / 3 + 40)];
        [iv sd_setImageWithURL:self.imgArr[i] placeholderImage:[UIImage imageNamed:@"newsImgV_default"]];
        [self.npView.imgSV addSubview:iv];
    }
    self.npView.indexLb.text = [NSString stringWithFormat:@"1 / %ld",self.npVM.rowNum];
    self.npView.setnameLb.text = [self.npVM setname];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.npVM refreshDataByUrlString:self.urlString CompleteHandle:^(NSError *error) {
        [self.imgArr removeAllObjects];
        for (int i = 0; i < self.npVM.rowNum; i++) {
            [self.imgArr addObject:[self.npVM imgurlForRow:i]];
        }
        [self initView];
    }];
    [Factory addBackItemToVC:self];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        //友盟分享调用
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:[NSString stringWithFormat:@"%@,%@",self.newsTitle,[self.npVM url]]
                                         shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[self.npVM cover]]]
                                    shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                           delegate:self];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [self.npVM url];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [self.npVM url];
    }];
    self.navigationItem.rightBarButtonItem = shareButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSInteger contentX = (NSInteger)targetContentOffset->x;
    NSInteger contentWidth = (NSInteger)kWindowW;
    NSInteger index = contentX / contentWidth + 1;
    self.npView.indexLb.text = [NSString stringWithFormat:@"%ld / %ld",index,self.npVM.rowNum];
    self.npView.noteLb.text = [self.npVM noteForRow:(index - 1)];
    //自适应高度
    CGRect txtFrame = self.npView.noteLb.frame;
    txtFrame.size.height = [self.npView.noteLb.text boundingRectWithSize:
                            CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                              attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.npView.noteLb.font,NSFontAttributeName, nil] context:nil].size.height;
    self.npView.noteLb.frame = CGRectMake(margin, 100, 300, txtFrame.size.height);
    self.npView.noteLb.frame = CGRectMake(margin, noteWidth + margin * 2, kWindowW - margin * 2, txtFrame.size.height);
    //设置notesSV滚动视图contentSize的高度为label的自适应高度
    self.npView.noteSV.contentSize = CGSizeMake(kWindowW, txtFrame.size.height + 2 * margin + noteWidth);
}
@end
