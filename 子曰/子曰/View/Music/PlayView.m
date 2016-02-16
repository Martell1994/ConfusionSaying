//
//  PlayView.m
//  子曰
//
//  Created by Martell on 15/12/2.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "PlayView.h"

@interface PlayView()
@end

@implementation PlayView

+ (PlayView *)sharedInstance {
    static PlayView *p = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p = [PlayView new];
    });
    return p;
}

- (UIImageView *)bgImgV {
    if (!_bgImgV) {
        _bgImgV = [UIImageView new];
        [self addSubview:_bgImgV];
        [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [_bgImgV addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _bgImgV;
}

- (SongTitleScrollView *)songSV {
    NSString *songName = [PlayView sharedInstance].musicDic[@"song"];
    if (!_songSV) {
        _songSV = [[SongTitleScrollView alloc] initWithLbTxt:songName];
        [self addSubview:_songSV];
        [_songSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW - 90, 30));
            make.top.mas_equalTo(30);
        }];
        
    }
    [_songSV setValue:songName forKeyPath:@"titleLb.text"];
    [_songSV recal:songName];
    return _songSV;
}

- (SongTitleScrollView *)albumSV {
    NSString *albumName = [[[PlayView sharedInstance].musicDic[@"singer"] stringByAppendingString:@" - "] stringByAppendingString:[PlayView sharedInstance].musicDic[@"album"]];
    if (!_albumSV) {
        _albumSV = [[SongTitleScrollView alloc] initWithLbTxt:albumName];
        [self addSubview:_albumSV];
        [_albumSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW - 90, 30));
            make.top.mas_equalTo(self.songSV.mas_bottom).mas_equalTo(5);
        }];
    }
    [_albumSV setValue:albumName forKeyPath:@"titleLb.text"];
    [_albumSV setValue:[UIFont systemFontOfSize:15] forKeyPath:@"titleLb.font"];
    [_albumSV recal:albumName];
    return _albumSV;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(13);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)favorBtn {
    if (!_favorBtn) {
        _favorBtn = [UIButton new];
        [self addSubview:_favorBtn];
        [_favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    }
    return _favorBtn;
}

-(UIProgressView *)songProgress {
    if (!_songProgress) {
        _songProgress = [UIProgressView new];
        [self addSubview:_songProgress];
        [_songProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(self.albumCoverMaskImgV.mas_bottom).mas_equalTo(30);
            make.height.mas_equalTo(3);
        }];
        _songProgress.tintColor = [UIColor whiteColor];
    }
    return _songProgress;
}

- (UILabel *)currentTimeLb {
    if (!_currentTimeLb) {
        _currentTimeLb = [UILabel new];
        [self addSubview:_currentTimeLb];
        [_currentTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.songProgress.mas_left);
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.top.mas_equalTo(self.songProgress.mas_bottom).mas_equalTo(3);
        }];
        _currentTimeLb.textColor = [UIColor whiteColor];
        _currentTimeLb.text = @"00:00";
        _currentTimeLb.font = [UIFont systemFontOfSize:15];
    }
    return _currentTimeLb;
}

- (UILabel *)totalTimeLb {
    if (!_totalTimeLb) {
        _totalTimeLb = [UILabel new];
        [self addSubview:_totalTimeLb];
        [_totalTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.songProgress.mas_right);
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.top.mas_equalTo(self.songProgress.mas_bottom).mas_equalTo(3);
        }];
        _totalTimeLb.textAlignment = NSTextAlignmentRight;
        _totalTimeLb.textColor = [UIColor whiteColor];
        _totalTimeLb.font = [UIFont systemFontOfSize:15];
    }
    return _totalTimeLb;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton new];
        [self addSubview:_downloadBtn];
        [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentTimeLb.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(self.currentTimeLb.mas_left);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    return _downloadBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton new];
        [self addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.downloadBtn.mas_top);
            make.left.mas_equalTo(self.downloadBtn.mas_right).mas_equalTo((kWindowW - 140) / 3);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    return _shareBtn;
}

- (UIButton *)modeBtn {
    if (!_modeBtn) {
        _modeBtn = [UIButton new];
        [self addSubview:_modeBtn];
        [_modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.downloadBtn.mas_top);
            make.left.mas_equalTo(self.shareBtn.mas_right).mas_equalTo((kWindowW - 140) / 3);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [_modeBtn setBackgroundImage:[UIImage imageNamed:@"icon_shuffleCycle"] forState:UIControlStateNormal];
    }
    return _modeBtn;
}

- (UIButton *)listBtn {
    if (!_listBtn) {
        _listBtn = [UIButton new];
        [self addSubview:_listBtn];
        [_listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.downloadBtn.mas_top);
            make.left.mas_equalTo(self.modeBtn.mas_right).mas_equalTo((kWindowW - 140) / 3);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [_listBtn setBackgroundImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
    }
    return _listBtn;
}

- (MImageView *)albumCoverImgV {
    if (!_albumCoverImgV) {
        _albumCoverImgV = [MImageView new];
        [self addSubview:_albumCoverImgV];
        [_albumCoverImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW - 50, kWindowW - 50));
            make.top.mas_equalTo(self.albumSV.mas_bottom).mas_equalTo(20);
            make.centerX.mas_equalTo(0);
        }];
        _albumCoverImgV.layer.cornerRadius = kWindowW / 2 - 25;
    }
    return _albumCoverImgV;
}

- (MImageView *)albumCoverMaskImgV {
    if (!_albumCoverMaskImgV) {
        _albumCoverMaskImgV = [MImageView new];
        [self addSubview:_albumCoverMaskImgV];
        _albumCoverMaskImgV.imageView.backgroundColor = kRGBColor(214, 207, 201);
        [_albumCoverMaskImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kWindowW - 40);
            make.top.mas_equalTo(self.albumSV.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(20);
        }];
        _albumCoverMaskImgV.layer.cornerRadius = kWindowW / 2 - 20;
    }
    return _albumCoverMaskImgV;
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
                [self.albumCoverImgV stopRotation];
                [_player pause];
            } else {
                [_player play];
                [self.albumCoverImgV rotation:15];
            }
            sender.selected = !sender.selected;
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-40);
            make.left.mas_equalTo(self.playBtn.mas_right).mas_equalTo(kWindowW / 8);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"toolbar_next_n"] forState:UIControlStateNormal];
    }
    return _nextBtn;
}

- (UIButton *)prevBtn {
    if (!_prevBtn) {
        _prevBtn = [UIButton new];
        [self addSubview:_prevBtn];
        [_prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-40);
            make.right.mas_equalTo(self.playBtn.mas_left).mas_equalTo(-kWindowW / 8);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        [_prevBtn setBackgroundImage:[UIImage imageNamed:@"toolbar_prev_n"] forState:UIControlStateNormal];
    }
    return _prevBtn;
}

- (void)playWithURL:(NSURL *)musicURL {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //激活
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    _player = [AVPlayer playerWithURL:musicURL];
    //动画令albumCoverImgV旋转
    CGRect endFrame = self.frame;
    CGRect startFrame = endFrame;
    startFrame.origin.x = - startFrame.size.width;
    self.frame = startFrame;
    [UIView animateWithDuration:1 animations:^{
        self.frame = endFrame;
        [self.albumCoverImgV rotation:15];
        [_player play];
        [self startPlayingTimer];
    }];
    self.playBtn.selected = YES;
}

//启动计时器
- (void)startPlayingTimer {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

//计时器每秒调用的方法
- (void)updateTimer:(NSTimer *)timer {
    NSTimeInterval duration = [self timeByInterval:self.totalTimeLb.text];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    self.songProgress.progress = currentTime * 1.0 / duration;
    self.currentTimeLb.text = [self stringByTime:currentTime];
    if ([self.currentTimeLb.text isEqualToString:self.totalTimeLb.text]) {
        [self.albumCoverImgV stopRotation];
    }
}

//时间标签转换
- (NSString *)stringByTime:(NSTimeInterval)time {
    return [NSString stringWithFormat:@"%02d:%02d",(int)time / 60, (int)time % 60];
}

- (NSTimeInterval)timeByInterval:(NSString *)time {
    NSArray *array = [time componentsSeparatedByString:@":"];
    NSString *min = array[0];
    NSString *sec = array[1];
    return [min integerValue] * 60 + [sec integerValue];
}

@end
