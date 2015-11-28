//
//  MImageView.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MImageView.h"

@implementation MImageView

- (id)init {
    if (self = [super init]) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        //按比例放大
        _imageView.contentMode = 2;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //当前视图容易剪掉超出自身区域的视图
        self.clipsToBounds = YES;
    }
    return self;
}

@end
