//
//  MusicCategoryCell.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicCategoryCell.h"

@implementation MusicCategoryCell

- (UILabel *)orderLb {
    if(_orderLb == nil) {
        _orderLb = [[UILabel alloc] init];
        _orderLb.font = LB20;
        _orderLb.textColor = [UIColor lightGrayColor];
        _orderLb.textAlignment = NSTextAlignmentCenter;
        _orderLb.numberOfLines = 0;
        [self.contentView addSubview:_orderLb];
        //使用KVO-键值观察 如果test被赋值为1 颜色是...
        //下方方法:如果_orderLb的text属性 被赋新值 则触发task
        [_orderLb bk_addObserverForKeyPath:@"text" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
            NSString *value = change[@"new"];
            if ([value isEqualToString:@"1"]) {
                _orderLb.text = @"状元";
                _orderLb.textColor = [UIColor redColor];
            } else if ([value isEqualToString:@"2"]){
                _orderLb.text = @"榜眼";
                _orderLb.textColor = kRGBColor(217, 210, 168);
            } else if ([value isEqualToString:@"3"]){
                _orderLb.text = @"探花";
                _orderLb.textColor = kRGBColor(137, 159, 147);
            }else{
                _orderLb.textColor = [UIColor blackColor];
            }
        }];
        [self.orderLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(35);
        }];
    }
    return _orderLb;
}

- (MImageView *)iconIV {
    if(_iconIV == nil) {
        _iconIV = [[MImageView alloc] init];
        [self.contentView addSubview:_iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(65, 65));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.orderLb.mas_right).mas_equalTo(0);
        }];
    }
    return _iconIV;
}

- (UILabel *)titleLb {
    if(_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.topMargin.mas_equalTo(self.iconIV.mas_topMargin).mas_equalTo(3);
            make.left.mas_equalTo(self.iconIV.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    return _titleLb;
}

- (UILabel *)descLb {
    if(_descLb == nil) {
        _descLb = [[UILabel alloc] init];
        _descLb.font = [UIFont systemFontOfSize:14];
        _descLb.textColor = kRGBColor(126, 127, 126);
        [self.contentView addSubview:_descLb];
        [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.iconIV.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    return _descLb;
}

- (UILabel *)numberLb {
    if(_numberLb == nil) {
        _numberLb = [[UILabel alloc] init];
        _numberLb.font = [UIFont systemFontOfSize:12];
        _numberLb.textColor = kRGBColor(126, 127, 126);
        [self.contentView addSubview:_numberLb];
        [self.numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.numberIV.mas_right).mas_equalTo(2);
            make.right.mas_equalTo(-10);
            make.bottomMargin.mas_equalTo(self.iconIV.mas_bottomMargin).mas_equalTo(-3);
            make.centerY.mas_equalTo(self.numberIV);
        }];
    }
    return _numberLb;
}

- (MImageView *)numberIV {
    if(_numberIV == nil) {
        _numberIV = [[MImageView alloc] init];
        _numberIV.imageView.image = [UIImage imageNamed:@"album_tracks"];
        [self.contentView addSubview:_numberIV];
        [self.numberIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconIV.mas_right).mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _numberIV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //右箭头样式
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //添加依赖autolayout 一定要有顺序 即从左到右 从上到下
        //分割线左间距调整
        self.separatorInset = UIEdgeInsetsMake(0, 105, 0, 0);
    }
    return self;
}

@end
