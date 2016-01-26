//
//  MyHeaderCell.m
//  子曰
//
//  Created by Martell on 15/11/4.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MyHeaderCell.h"

@interface MyHeaderCell()
@property (nonatomic, strong) NSString *plistPath;
@end

@implementation MyHeaderCell

plistPath_lazy
getPlistDic

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    return _nameLabel;
}

- (UILabel *)joinTimeLabel {
    if (!_joinTimeLabel) {
        _joinTimeLabel = [UILabel new];
    }
    return _joinTimeLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    return _detailLabel;
}

- (void)addHeaderImage {
    [self.contentView addSubview:self.headImageView];
    NSString *imageName = [[self PlistDic] objectForKey:@"headerImage"];
    if ([imageName isEqualToString:@"userImg_default"]) {
        _headImageView.image = [UIImage imageNamed:@"userImg_default"];
    } else {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(16);
        make.width.height.mas_equalTo(70);
    }];
    _headImageView.layer.cornerRadius = 35;
    _headImageView.layer.masksToBounds = YES;
}

- (void)addNameLable {
    [self.contentView addSubview:self.nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(96);
        make.top.mas_equalTo(10);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:20];
}

- (void)addJoinTimeLable {
    [self.contentView addSubview:self.joinTimeLabel];
    [_joinTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.top.mas_equalTo(_nameLabel.mas_bottom).mas_equalTo(10);
    }];
    _joinTimeLabel.font = [UIFont systemFontOfSize:15];
    _joinTimeLabel.textColor = [UIColor lightGrayColor];
}

- (void)addDetailLabel {
    [self.contentView addSubview:self.detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    _detailLabel.text = @"修改信息";
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.font = [UIFont systemFontOfSize:17];
    _detailLabel.textColor = [UIColor lightGrayColor];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addHeaderImage];
        [self addDetailLabel];
        [self addNameLable];
        [self addJoinTimeLable];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.plistPath]) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.plistPath];
            _nameLabel.text = [dic objectForKey:@"name"];
            _joinTimeLabel.text = [NSString stringWithFormat:@"%@加入",[dic objectForKey:@"createdTime"]];
        }
    }
    return self;
}
@end
