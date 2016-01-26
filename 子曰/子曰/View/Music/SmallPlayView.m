//
//  SmallPlayView.m
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "SmallPlayView.h"

@implementation SmallPlayView

+ (SmallPlayView *)sharedInstance {
    static SmallPlayView *sp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sp = [SmallPlayView new];
    });
    return sp;
}

- (id)init {
    if (self = [super init]) {
        self.playViewBtn.hidden = NO;
    }
    return self;
}

- (UIButton *)playViewBtn {
    if (!_playViewBtn) {
        _playViewBtn = [[UIButton alloc] init];
        [self addSubview:_playViewBtn];
        [_playViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_playViewBtn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    }
    return _playViewBtn;
}

@end
