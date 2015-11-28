//
//  EditAccCell.m
//  子曰
//
//  Created by Martell on 15/11/7.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "EditAccCell.h"

@implementation EditAccCell

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor grayColor];
    }
    return _tipLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleNone;
    }
    return _textField;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.tipLabel];
        [self addSubview:self.textField];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_tipLabel.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(20);
            make.centerY.mas_equalTo(self);
        }];
        _textField.tintColor = [UIColor grayColor];
    }
    return self;
}


@end

@implementation EditAccChoice

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor grayColor];
    }
    return _tipLabel;
}

- (UILabel *)editLabel {
    if (!_editLabel) {
        _editLabel = [UILabel new];
        _editLabel.font = [UIFont systemFontOfSize:15];
        _editLabel.textColor = [UIColor grayColor];
    }
    return _editLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.tipLabel];
        [self addSubview:self.editLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        [_editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_tipLabel.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(20);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}

@end
