//
//  NewsHtmlViewController.m
//  子曰
//
//  Created by Martell on 16/1/22.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsHtmlViewController.h"
#import "NewsHtmlViewModel.h"

@interface NewsHtmlViewController ()<UIWebViewDelegate, UMSocialUIDelegate>
@property (nonatomic, strong) NewsHtmlViewModel *nhVM;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) UIBarButtonItem *favorButtonItem;
@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;
@property (nonatomic, strong) NSString *docId;
@property (nonatomic, strong) NSURL *newsImage;
@end

@implementation NewsHtmlViewController

- (instancetype)initWithDocId:(NSString *)docId withNewsImage:(NSURL *)newsImage{
    if (self = [super init]) {
        self.docId = docId;
        self.newsImage = newsImage;
    }
    return self;
}
- (NewsHtmlViewModel *)nhVM{
    if (!_nhVM) {
        _nhVM = [[NewsHtmlViewModel alloc]init];
    }
    return _nhVM;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        [self.view addSubview:_webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _webView.delegate = self;
    }
    return _webView;
}

- (AppDelegate *)delegate {
    if (!_delegate) {
        _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _delegate;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //出发webview懒加载
    self.webView.alpha = 1.0;
    [self.nhVM refreshDataByDocId:self.docId CompleteHandle:^(NSError *error) {
        [self showInWebView];
    }];
    [Factory addBackItemToVC:self];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.shareButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        //友盟分享调用
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:[NSString stringWithFormat:@"%@,%@",[self.nhVM title],[self.nhVM sourceUrl]]
                                         shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:self.newsImage]]
                                    shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                           delegate:self];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [self.nhVM sourceUrl];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [self.nhVM sourceUrl];
    }];
    if (delegate.loginOrNot) {
        [self favorTap];
    } else {
        self.favorButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self showMsg:@"请先登录"];
        }];
        self.navigationItem.rightBarButtonItems = @[self.favorButtonItem,self.shareButtonItem];
    }
    for (id subview in self.webView.subviews){
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
        }
    }
}

- (void)favorTap {
    BmobQuery *bquery = [BmobQuery new];
    NSString *selectSql = [NSString stringWithFormat:@"select *from ZY_NewsFavor where newsId = '%@' and userId = '%@'",self.docId, self.delegate.userId];
    [bquery queryInBackgroundWithBQL:selectSql block:^(BQLQueryResult *result, NSError *error) {
        if (error) {
            NSLog(@"收藏新闻时查询数据失败，原因为%@",error);
        } else {
            if (result.resultsAry.count) {
                BmobObject *obj = (BmobObject *)result.resultsAry[0];
                self.favorButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"collected"] style:UIBarButtonItemStylePlain handler:^(id sender) {
                    BmobObject *cancelObject = [BmobObject objectWithoutDatatWithClassName:@"ZY_NewsFavor" objectId:[obj objectId]];
                    [cancelObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [self showMsg:@"取消收藏"];
                            [self favorTap];
                        } else if (error) {
                            [self showErrorMsg:[NSString stringWithFormat:@"取消收藏失败，原因是:%@",error.userInfo]];
                        } else{
                            [self showErrorMsg:@"取消收藏失败，原因未知"];
                        }
                    }];
                }];
            }else {
                self.favorButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"collect"] style:UIBarButtonItemStylePlain handler:^(id sender) {
                    BmobObject *newsFavor = [[BmobObject alloc] initWithClassName:@"ZY_NewsFavor"];
                    [newsFavor setObject:self.delegate.userId forKey:@"userId"];
                    [newsFavor setObject:self.docTitle forKey:@"newsTitle"];
                    [newsFavor setObject:self.docId forKey:@"newsId"];
                    [newsFavor setObject:self.imgStr forKey:@"newsImage"];
                    [newsFavor saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [self showMsg:@"收藏成功"];
                            [self favorTap];
                        } else {
                            [self showErrorMsg:[NSString stringWithFormat:@"新闻收藏失败，原因是:%@",error.userInfo]];
                        }
                    }];
                }];
            }
            self.navigationItem.rightBarButtonItems = @[self.favorButtonItem,self.shareButtonItem];
        }
    }];
}

#pragma mark - 拼接html语言
- (void)showInWebView {
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"NewsHtml.css" withExtension:nil]];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody {
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",[self.nhVM title]];
    [body appendFormat:@"<div class=\"time\">%@</div>",[self.nhVM ptime]];
    if ([self.nhVM body] != nil) {
        [body appendString:[self.nhVM body]];
    }
    // 遍历img
    for (int i = 0; i < self.nhVM.imgRowNum; i++) {
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        // 数组存放被切割的像素
        NSArray *pixel = [[self.nhVM pixelForRow:i] componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,[self.nhVM srcForRow:i]];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:[self.nhVM refForRow:i] withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

#pragma mark - ******************** 保存到相册方法
- (void)savePictureToAlbum:(NSString *)src
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self showSuccessMsg:@"保存成功"];
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:src="];
    if (range.location != NSNotFound) {
        NSInteger begin = range.location + range.length;
        NSString *src = [url substringFromIndex:begin];
        [self savePictureToAlbum:src];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showProgressOn:self.view]; //旋转提示
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideProgressOn:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showErrorMsg:@"出错啦～"];
}


@end
