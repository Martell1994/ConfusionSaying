//
//  WebImgScrollView.m
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "WebImgScrollView.h"

static CGFloat const animationDutation = 0.2f;

@interface WebImgScrollView  ()<UIScrollViewDelegate>

//图片的大小
@property (nonatomic, assign) CGSize imgSize;
//图片
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollView;
//和scrollview一般大的缩放用的
@property (nonatomic, strong) UIView *scaleView;

@property (nonatomic, strong) UIButton *downLoadBtn;

@end

@implementation WebImgScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

+ (WebImgScrollView *)showImageWithStr:(NSString *)url{
    
    WebImgScrollView *imgSV = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:imgSV];
    imgSV.imgUrl = url;
    
    return imgSV;
}


#pragma mark - UIScrollView  delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scaleView;
}

#pragma mark - private method
- (void)initSubViews{
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.f;
    
    
    [self.scrollView addSubview:self.scaleView];
    [self.scaleView addSubview:self.imageView];
    [self addSubview:self.downLoadBtn];
    
    [UIView animateWithDuration:animationDutation animations:^{
        self.alpha = 0.8f;
    }];
    
}

- (void)calculateImageFrame:(UIImage *)image{
    
    self.imageView.image = image;

    float scaleX = self.scrollView.frame.size.width / image.size.width;
    float scaleY = self.scrollView.frame.size.height / image.size.height;
    
    if (scaleX > scaleY)
    {
        float imgViewWidth = image.size.width * scaleY;
        
        self.imageView.frame = CGRectMake((self.scrollView.frame.size.width - imgViewWidth) * 0.5,0 ,imgViewWidth, self.scrollView.frame.size.height);
    }else{
        float imgViewHeight = image.size.height*scaleX;
        
        self.imageView.frame = CGRectMake(0, (self.scrollView.frame.size.height - imgViewHeight) * 0.5, self.scrollView.frame.size.width, imgViewHeight);
    }
    
    self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:animationDutation animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
    }];
    
}



- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    [self showSuccessMsg:@"已添加到相册"];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeView];
}

- (void)removeView{
    [UIView animateWithDuration:animationDutation animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.alpha = 0.5;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.scrollView removeFromSuperview];
    }];
}

#pragma mark - setter and getter
- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.scrollView];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.image = image;
        [self calculateImageFrame:image];
    }];
    
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.frame = CGRectMake(0, 0, kWindowW, kWindowH - 40);
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)scaleView{
    if (_scaleView == nil) {
        _scaleView = [[UIView alloc] init];
        _scaleView.frame = _scrollView.frame;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        [_scaleView addGestureRecognizer:tap];
        _scaleView.backgroundColor = [UIColor clearColor];
    }
    return _scaleView;
}

- (UIButton *)downLoadBtn{
    if (_downLoadBtn == nil) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn bk_addEventHandler:^(id sender) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self showErrorMsg:@"无法读取相册"];
            }
            UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        } forControlEvents:UIControlEventTouchUpInside];
        [_downLoadBtn setImage:[UIImage imageNamed:@"News_Picture_Save"] forState:UIControlStateNormal];
        _downLoadBtn.frame = CGRectMake(kWindowW - 50, kWindowH - 40, _downLoadBtn.frame.size.width, _downLoadBtn.frame.size.height);
        [_downLoadBtn sizeToFit];
    }
    return _downLoadBtn;
}

@end
