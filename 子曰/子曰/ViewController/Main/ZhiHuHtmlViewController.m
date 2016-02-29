//
//  ZhiHuHtmlViewController.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuHtmlViewController.h"
#import "ZhiHuHtmlViewModel.h"
#import "WebImgScrollView.h"

@interface ZhiHuHtmlViewController () <UIWebViewDelegate>
@property (nonatomic, strong) ZhiHuHtmlViewModel *zhVM;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *topIV;
@property (nonatomic, strong) NSString *htmlStr;
@property (nonatomic, assign) BOOL favorOrNot;
@property (nonatomic, strong) AppDelegate *delegate;

/** 链接正确，但是返回的body无内容时弹出提示视图 */
@property (nonatomic, strong) UIImageView *bodyNilIV;

@end

@implementation ZhiHuHtmlViewController

- (instancetype)initWithStoryId:(NSInteger)storyId{
    if (self = [super init]) {
        self.storyId = storyId;
    }
    return self;
}

- (AppDelegate *)delegate {
    if (!_delegate) {
        _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _delegate;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        [self.view addSubview:_webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.bottom.mas_equalTo(0);
        }];
        _webView.delegate = self;
    }
    return _webView;
}

- (ZhiHuHtmlViewModel *)zhVM{
    if (!_zhVM) {
        _zhVM = [[ZhiHuHtmlViewModel alloc]init];
    }
    return _zhVM;
}

- (UIImageView *)topIV{
    if (!_topIV) {
        _topIV = [[UIImageView alloc]init];
    }
    return _topIV;
}

- (UIImageView *)bodyNilIV{
    if (!_bodyNilIV) {
        _bodyNilIV = [[UIImageView alloc]init];
    }
    return _bodyNilIV;
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
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.intoType) {
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_white"] forBarMetrics:UIBarMetricsDefault];
    }
    if (self.delegate.loginOrNot) {
        [self favorTap];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self showMsg:@"请先登录"];
        }];
    }
    [self.zhVM refreshDataByStoryId:self.storyId CompleteHandle:^(NSError *error) {
        if ([self.zhVM body] == nil) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[self.zhVM shareUrl]]];
        }else{
            self.htmlStr = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",self.zhVM.css[0],self.zhVM.body];
            [self.webView loadHTMLString:self.htmlStr baseURL:nil];
            //判断页面上方有无图片
            if ([self.zhVM image]) {
                [self.webView.scrollView addSubview:self.topIV];
                [self.topIV sd_setImageWithURL:[self.zhVM image] placeholderImage:[UIImage imageNamed:@"News_Avatar"]];
                [self.topIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                    //css文件中得到的头部图片的高度为200（搜索.img-place-holder属性）
                    make.size.mas_equalTo(CGSizeMake(kWindowW, 200));
                }];
            }
        }
    }];
    for (id subview in self.webView.subviews){
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
        }
    }
}

- (void)favorTap {
    BmobQuery *bquery = [BmobQuery new];
    NSString *storyId = [NSString stringWithFormat:@"%ld",self.storyId];
    NSString *selectSql = [NSString stringWithFormat:@"select *from ZY_ArticleFavor where articleId = '%@' and userId = '%@'",storyId, self.delegate.userId];
    [bquery queryInBackgroundWithBQL:selectSql block:^(BQLQueryResult *result, NSError *error) {
        if (error) {
            NSLog(@"收藏文章时查询数据失败，原因为%@",error);
        } else {
            if (result.resultsAry.count) {
                _favorOrNot = YES;
                BmobObject *obj = (BmobObject *)result.resultsAry[0];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"collected"] style:UIBarButtonItemStylePlain handler:^(id sender) {
                    BmobObject *cancelObject = [BmobObject objectWithoutDatatWithClassName:@"ZY_ArticleFavor" objectId:[obj objectId]];
                    [cancelObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [self showMsg:@"取消收藏"];
                            self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"collect"];
                            _favorOrNot = NO;
                            [self favorTap];
                        } else if (error) {
                            NSLog(@"取消收藏文章时失败，原因为%@",error);
                        } else{
                            NSLog(@"取消收藏文章时失败，原因未知");
                        }
                    }];
                    
                }];
            }
        }
    }];
    if (_favorOrNot == NO) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            BmobObject *articleFavor = [[BmobObject alloc] initWithClassName:@"ZY_ArticleFavor"];
            [articleFavor setObject:self.delegate.userId forKey:@"userId"];
            [articleFavor setObject:self.storyTitle forKey:@"articleTitle"];
            [articleFavor setObject:self.storySource forKey:@"articleSource"];
            [articleFavor setObject:storyId forKey:@"articleId"];
            [articleFavor saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [self showMsg:@"收藏成功"];
                    self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"collected"];
                    _favorOrNot = YES;
                    [self favorTap];
                } else {
                    NSLog(@"文章收藏失败，原因是：error:%@",error);
                }
            }];
        }];
    }
}


#pragma mark - webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.absoluteString;
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:" withString:@""];
        [WebImgScrollView showImageWithStr:str];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showProgressOn:self.view]; //旋转提示
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    //js方法遍历图片添加点击事件 返回图片个数
    static NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    [self hideProgressOn:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self  showErrorMsg:@"出错啦!"];
}

@end
