//
//  PlayView.m
//  子曰
//
//  Created by Martell on 15/12/2.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

+ (PlayView *)sharedInstance {
    static PlayView *p = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p = [PlayView new];
    });
    return p;
}

- (id)init {
    if (self = [super init]) {
        self.playBtn.hidden = NO;
    }
    return self;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:0];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"toolbar_play_n_p"] forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"toolbar_pause_n_p"] forState:UIControlStateSelected];
        [self addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        [_playBtn bk_addEventHandler:^(UIButton *sender) {
            if (sender.selected) {
                [_player pause];
            } else {
                [_player play];
            }
            sender.selected = !sender.selected;
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(30);
        }];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"arrowback"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (void)playWithURL:(NSURL *)musicURL {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //激活
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    _player = [AVPlayer playerWithURL:musicURL];
    [_player play];
    self.playBtn.selected = YES;
}
//- (void)playWithLocalUrl:(NSURL *)musicURL {
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    //激活
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    
//    
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
//    _player = [AVPlayer playerWithURL:musicURL];
//    [_player play];
//    self.playBtn.selected = YES;
//}

@end
