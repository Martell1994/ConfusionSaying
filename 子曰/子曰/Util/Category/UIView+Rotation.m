//
//  UIView+Rotation.m
//  子曰
//
//  Created by Martell on 16/1/29.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "UIView+Rotation.h"

@implementation UIView (Rotation)
- (void)rotation:(NSTimeInterval)duration {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = 2147483647;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"UIViewRotation"];
}
- (void)stopRotation {
    [self.layer removeAnimationForKey:@"UIViewRotation"];
}
@end
