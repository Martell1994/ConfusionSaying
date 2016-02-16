//
//  LogoutCell.m
//  子曰
//
//  Created by Martell on 16/1/28.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "LogoutCell.h"
#define cell_Margin (kWindowW - 302) / 2.0
@implementation LogoutCell

- (UIImageView *)bgImgV {
    if (!_bgImgV) {
        _bgImgV = [UIImageView new];
        [self addSubview:_bgImgV];
        [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _bgImgV.image = [UIImage imageNamed:@"logoutCell_bg"];
    }
    return _bgImgV;
}

- (MImageView *)headImgV {
    if (!_headImgV) {
        _headImgV = [MImageView new];
        [self addSubview:_headImgV];
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(90);
        }];
        [_headImgV.imageView setImage:[UIImage imageNamed:@"userImg_default"]];
        _headImgV.layer.cornerRadius = 45;
    }
    return _headImgV;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        [self addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgV.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(30);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        _loginBtn.backgroundColor = dColor;
        _loginBtn.layer.cornerRadius = 5;
    }
    return _loginBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
        [self addSubview:_registerBtn];
        [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgV.mas_bottom).mas_equalTo(15);
            make.right.mas_equalTo(-30);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        _registerBtn.backgroundColor = dColor;
        _registerBtn.layer.cornerRadius = 5;
    }
    return _registerBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.bgImgV.hidden = NO;
        self.headImgV.hidden = NO;
        [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        [self.registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
    }
    return self;
}

@end
