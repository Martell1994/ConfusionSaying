//
//  ArticleCell.m
//  子曰
//
//  Created by Martell on 16/2/16.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

- (UILabel *)sourceLb {
    if (!_sourceLb) {
        _sourceLb = [UILabel new];
        [self addSubview:_sourceLb];
        [_sourceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(kWindowW / 2 - 13);
        }];
        _sourceLb.font = [UIFont systemFontOfSize:14];
        _sourceLb.textColor = [UIColor grayColor];
    }
    return _sourceLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [self addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(15);
        }];
        _timeLb.font = [UIFont systemFontOfSize:12];
        _timeLb.textColor = [UIColor grayColor];
        _timeLb.textAlignment = NSTextAlignmentRight;
    }
    return _timeLb;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sourceLb.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(45);
        }];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

@end
