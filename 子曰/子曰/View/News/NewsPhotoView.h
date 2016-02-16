//
//  NewsPhotoView.h
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsPhotoView : UIView
@property (nonatomic,strong) UIScrollView *imgSV;
@property (nonatomic,strong) UILabel *setnameLb;
@property (nonatomic,strong) UILabel *indexLb;
@property (nonatomic,strong) UILabel *noteLb;
@property (nonatomic,strong) UIScrollView *noteSV;
- (instancetype)initWithNote:(NSString *)note InView:(UIView *)view;
@end
