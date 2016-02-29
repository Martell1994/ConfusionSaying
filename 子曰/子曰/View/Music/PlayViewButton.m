//
//  PlayViewButton.m
//  子曰
//
//  Created by soft on 16/2/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "PlayViewButton.h"

@implementation PlayViewButton

+ (DraggableButton *)standardPlayViewBtn{
    static DraggableButton *btn = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        btn = [[DraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(kWindowW - 35, 25, 30, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"playerBall"] forState:UIControlStateNormal];
    });
    return btn;
}

@end
