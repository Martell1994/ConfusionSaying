//
//  UIView+Rotation.h
//  子曰
//
//  Created by Martell on 16/1/29.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rotation)
//让当前视图顺时针不断旋转
- (void)rotation:(NSTimeInterval)duration;
//停止旋转动画
- (void)stopRotation;
@end
