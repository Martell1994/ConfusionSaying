//
//  ArcView.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ArcView.h"

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@implementation ArcView
- (UIImageView *)iv1{
    if (!_iv1) {
        _iv1 = [[UIImageView alloc]init];
        _iv1.frame = CGRectMake(kWindowW / 2 - 75, 64 + 5, 40, 50);
        [self addSubview:_iv1];
    }
    return _iv1;
}
- (UILabel *)lb{
    if (!_lb) {
        _lb = [[UILabel alloc]init];
        _lb.frame = CGRectMake(kWindowW / 2 - 25, 64 + 15, 200, 20);
        [self addSubview:_lb];
    }
    return _lb;
}

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.progress];
    [color set];  //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kWindowW / 2, 64 + 27)
                                                         radius:20
                                                     startAngle:0
                                                       endAngle:DEGREES_TO_RADIANS(self.progress * 360)
                                                      clockwise:YES];
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [aPath stroke];
}


@end
