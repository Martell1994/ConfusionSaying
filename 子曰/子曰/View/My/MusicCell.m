//
//  MusicCell.m
//  子曰
//
//  Created by Martell on 16/1/24.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (UILabel *)songLb {
    if(_songLb == nil) {
        _songLb = [[UILabel alloc] init];
        [self.contentView addSubview:_songLb];
        [_songLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(kWindowW - 35);
        }];
        _songLb.numberOfLines = 1;
    }
    return _songLb;
}

- (UIImageView *)tickImageView {
    if (_tickImageView == nil) {
        _tickImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_tickImageView];
        [_tickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.songLb.mas_bottom).mas_equalTo(5);
            make.width.height.mas_equalTo(15);
            make.left.mas_equalTo(16);
        }];
    }
    return _tickImageView;
}

- (UILabel *)durationLb {
    if (_durationLb == nil) {
        _durationLb = [[UILabel alloc] init];
        [self.contentView addSubview:_durationLb];
        [_durationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tickImageView.mas_top);
            make.left.mas_equalTo(self.tickImageView.mas_right).mas_equalTo(8);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(15);
        }];
        _durationLb.font = [UIFont systemFontOfSize:13];
        _durationLb.textColor = kRGBColor(126, 127, 126);
    }
    return _durationLb;
}

- (UILabel *)singerLb {
    if (!_singerLb) {
        _singerLb = [UILabel new];
        [self.contentView addSubview:_singerLb];
        [_singerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tickImageView.mas_top);
            make.left.mas_equalTo(self.durationLb.mas_right).mas_equalTo(8);
            make.height.mas_equalTo(15);
        }];
        _singerLb.font = [UIFont systemFontOfSize:13];
        _singerLb.textColor = kRGBColor(126, 127, 126);
    }
    return _singerLb;
}

- (UILabel *)albumLb {
    if (_albumLb == nil) {
        _albumLb = [UILabel new];
        [self.contentView addSubview:_albumLb];
        [_albumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tickImageView.mas_top);
            make.left.mas_equalTo(self.singerLb.mas_right).mas_equalTo(5);
            make.height.mas_equalTo(15);
        }];
        _albumLb.font = [UIFont systemFontOfSize:13];
        _albumLb.textColor = kRGBColor(126, 127, 126);
    }
    return _albumLb;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
