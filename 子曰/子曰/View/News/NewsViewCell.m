//
//  NewsViewCell.m
//  子曰
//
//  Created by Martell on 16/1/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsViewCell.h"

@implementation NewsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgIV = [[UIImageView alloc]init];
        [self addSubview:self.imgIV];
        [self.imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(8);
            make.height.mas_equalTo(64);
            make.width.mas_equalTo(80);
        }]; 
        self.titleLb = [[UILabel alloc]init];
        self.titleLb.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgIV.mas_right).mas_equalTo(8);
            make.topMargin.mas_equalTo(self.imgIV.mas_topMargin).mas_equalTo(3);
        }];
        self.digestLb = [[UILabel alloc]init];
        self.digestLb.numberOfLines = 0;
        self.digestLb.textColor = [UIColor grayColor];
        self.digestLb.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.digestLb];
        [self.digestLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgIV.mas_right).mas_equalTo(8);
            make.top.mas_equalTo(self.titleLb.mas_bottom).mas_equalTo(5);
            make.right.mas_equalTo(-16);
            make.bottomMargin.mas_equalTo(self.imgIV.mas_bottomMargin).mas_equalTo(-3);
        }];
        
    }
    return self;
}

@end
