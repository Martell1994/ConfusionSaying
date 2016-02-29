//
//  PlayView.h
//  子曰
//
//  Created by Martell on 15/12/2.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongTitleScrollView.h"
enum musicListType {
    noneMusicType,
    networkMusicType,
    downloadMusicType
};

@interface PlayView : UIView
+ (PlayView *)sharedInstance;

- (void)playWithURL:(NSURL *)musicURL;
- (void)setAlbumCoverImgVRotation;

@property (nonatomic, assign) enum musicListType musicListType;
@property (nonatomic, strong) NSDictionary *musicDic;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSString *coverImageURL;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *prevBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *favorBtn;
@property (nonatomic, strong) MImageView *albumCoverImgV;
@property (nonatomic, strong) MImageView *albumCoverMaskImgV;
@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) SongTitleScrollView *songSV;
@property (nonatomic, strong) SongTitleScrollView *albumSV;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat songProgress;
@property (nonatomic,strong) UISlider *songSlider;
@property (nonatomic, strong) UILabel *currentTimeLb;
@property (nonatomic, strong) UILabel *totalTimeLb;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *modeBtn;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, strong) UISlider *voiceSlider;

@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, strong) NSMutableArray *playingList;
@property (nonatomic, assign) NSInteger songId;
@property (nonatomic, assign) BOOL isNetMusicList;

//启动计时器
- (void)startPlayingTimer;
//销毁计时器
- (void)invalidatePlayingTimer;

@end
