//
//  ZhiHuViewCell.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuViewCell.h"

@implementation ZhiHuViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        if ([reuseIdentifier isEqualToString:@"TopTxtCell"]) {
        self.iv = [[UIImageView alloc]init];
        [self addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(50);
        }];
        
        self.titleLb = [[UILabel alloc]init];
        self.titleLb.font = [UIFont systemFontOfSize:15];
        self.titleLb.numberOfLines = 0;
        [self addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.iv.mas_top);
            make.right.mas_equalTo(self.iv.mas_left).mas_equalTo(-10);
        }];
        
    }
    return self;
}

@end
