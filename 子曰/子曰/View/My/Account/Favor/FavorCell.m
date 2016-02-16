//
//  FavorCell.m
//  子曰
//
//  Created by Martell on 16/2/15.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "FavorCell.h"

@implementation FavorCell

- (UIButton *)articleFBtn {
    if (!_articleFBtn) {
        _articleFBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _articleFBtn.frame = CGRectMake((kWindowW - 90) / 6, 10, 30, 50);
        [self addSubview:_articleFBtn];
        [_articleFBtn setImage:[UIImage imageNamed:@"article"] forState:UIControlStateNormal];
        _articleFBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);//上左下右
        _articleFBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _articleFBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _articleFBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_articleFBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _articleFBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -33, 0, 0);
    }
    return _articleFBtn;
}


- (UIButton *)newsFBtn {
    if (!_newsFBtn) {
        _newsFBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _newsFBtn.frame = CGRectMake((kWindowW - 90) / 6 * 3 + 30, 10, 30, 50);
        [self addSubview:_newsFBtn];
        [_newsFBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
        _newsFBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
        _newsFBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _newsFBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _newsFBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_newsFBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _newsFBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -33, 0, 0);
    }
    return _newsFBtn;
}

- (UIButton *)songFBtn {
    if (!_songFBtn) {
        _songFBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _songFBtn.frame = CGRectMake((kWindowW - 90) / 6 * 5 + 60, 10, 30, 50);
        [self addSubview:_songFBtn];
        [_songFBtn setImage:[UIImage imageNamed:@"music"] forState:UIControlStateNormal];
        _songFBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
        _songFBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _songFBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _songFBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_songFBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _songFBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -33, 0, 0);

    }
    return _songFBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.articleFBtn setTitle:@"文章" forState:UIControlStateNormal];
        [self.newsFBtn setTitle:@"新闻" forState:UIControlStateNormal];
        [self.songFBtn setTitle:@"音乐" forState:UIControlStateNormal];
    }
    return self;
}

@end
