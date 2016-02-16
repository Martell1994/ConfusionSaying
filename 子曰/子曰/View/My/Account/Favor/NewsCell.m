//
//  NewsCell.m
//  子曰
//
//  Created by Martell on 16/2/16.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (UIImageView *)headImgV {
    if (!_headImgV) {
        _headImgV = [UIImageView new];
        [self addSubview:_headImgV];
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(75, 64));
        }];
        _headImgV.backgroundColor = [UIColor grayColor];
    }
    return _headImgV;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [self addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(12);
        }];
        _timeLb.font = [UIFont systemFontOfSize:12];
        _timeLb.textColor = [UIColor lightGrayColor];
        _timeLb.textAlignment = NSTextAlignmentRight;
    }
    return _timeLb;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLb.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(self.headImgV.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-8);
        }];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}



@end
