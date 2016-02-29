//
//  ArcView.h
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcView : UIView
//圆弧的进度 0 ～ 1
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic,strong) UIImageView *iv1;
@property (nonatomic,strong) UILabel *lb;
@end
