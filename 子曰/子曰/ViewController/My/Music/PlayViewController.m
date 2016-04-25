//
//  PlayViewController.m
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "PlayViewController.h"
#import "LoginViewController.h"
#import "PlayView.h"
#import "DownloadMusicNetManager.h"
#import "MPNowPlayingInfoManager.h"
#import "PlayListViewController.h"

#define PVSI [PlayView sharedInstance]

@interface PlayViewController ()<DownloadMusicNetManagerDelegate, UMSocialUIDelegate> {
    MPMediaItemArtwork *_artWork;
}
@property (nonatomic, copy) NSMutableArray *downloadArr;
@property (nonatomic, strong) NSMutableArray *favorArr;
@property (nonatomic, assign) BOOL likeOrNot;
@property (nonatomic, assign) BOOL downloadOrNot;
@property (nonatomic, strong) BmobObject *fObj;
@property (nonatomic, strong) DownloadMusicNetManager *dlmNetManager;
@property (nonatomic, assign) BOOL isPlay;//歌曲是否在播放
@property (nonatomic, assign) CGFloat maxVolume;
@end

@implementation PlayViewController

- (DownloadMusicNetManager *)dlmNetManager{
    if(!_dlmNetManager){
        _dlmNetManager = [DownloadMusicNetManager new];
        _dlmNetManager.delegate = self;
    }
    return _dlmNetManager;
}

- (NSMutableArray *)downloadArr {
    if (!_downloadArr) {
        NSString *plistPath = [DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"];
        _downloadArr = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return _downloadArr;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [PlayViewButton standardPlayViewBtn].hidden = NO;
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BmobQuery *bmobQuery = [BmobQuery new];
    self.favorArr = [NSMutableArray new];
    NSString *bql = [NSString stringWithFormat:@"select * from ZY_SongFavor where userId = '%@'",ZYDelegate.userId];
    [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        if (result) {
            for (BmobObject *obj in result.resultsAry) {
                [self.favorArr addObject:obj];
            }
        }
    }];
    [PlayViewButton standardPlayViewBtn].hidden = YES;
    //重新进入页面的时候让slider更新
    PVSI.songSlider.value = PVSI.songProgress;
    //进入页面的时候让timer
    [PVSI invalidatePlayingTimer];
    [PVSI startPlayingTimer];
    [self showBackBtn];
    [self showShareBtn];
    [self favorBtnTap];
    [self downloadBtnTap];
    [self tapMusic];
    [self moveSlider];
    //监听歌曲是否播放完成
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.likeOrNot = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self viewInit];
    //将播放界面加入VC中
    [self.view addSubview:PVSI];
    [PVSI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewInit {
    [self judgeDownload];
    if (PVSI.musicListType == downloadMusicType) {
        [self arrangeImgV];
    } else if (PVSI.musicListType == networkMusicType){
        //背景图片
        if (self.downloadOrNot == YES) {
            [self arrangeImgV];
        } else {
            [PVSI.bgImgV sd_setImageWithURL:[NSURL URLWithString:PVSI.coverImageURL] placeholderImage:[UIImage imageNamed:@"cell_bg_noData"]];
            //专辑图片
            PVSI.albumCoverMaskImgV.hidden = NO;
            [PVSI.albumCoverImgV.imageView sd_setImageWithURL:[NSURL URLWithString:PVSI.coverImageURL] placeholderImage:[UIImage imageNamed:@"cell_bg_noData"]];
        }
    } else {//没有播放源
        return;
    }
    //收藏按钮
    [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    if (ZYDelegate.loginOrNot) {
        BmobQuery *bquery = [BmobQuery new];
        if (self.favorType) {
            [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
            self.likeOrNot = YES;
        } else {
            NSString *selectSql = [NSString stringWithFormat:@"select *from ZY_SongFavor where songName = '%@' and userId = '%@'",PVSI.musicDic[@"song"], ZYDelegate.userId];
            [bquery queryInBackgroundWithBQL:selectSql block:^(BQLQueryResult *result, NSError *error) {
                if (result.resultsAry.count) {
                    [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
                    self.likeOrNot = YES;
                }
            }];
        }
    }
    //歌曲名
    PVSI.songSV.hidden = NO;
    //专辑名
    PVSI.albumSV.hidden = NO;
    //进度条
    PVSI.songSlider.value = 0;
    //现在播放时间
    PVSI.currentTimeLb.hidden = NO;
    //音乐时长
    PVSI.totalTimeLb.text = PVSI.musicDic[@"duration"];
    //四个按钮
    //[PVSI.shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];//分享
    PVSI.downloadBtn.enabled = YES;
    if (PVSI.musicListType == downloadMusicType || self.downloadOrNot) {//已下载的歌曲
        [PVSI.downloadBtn setBackgroundImage:[UIImage imageNamed:@"icon_downloaded"] forState:UIControlStateNormal];
        PVSI.downloadBtn.enabled = NO;
    } else {
        [PVSI.downloadBtn setBackgroundImage:[UIImage imageNamed:@"icon_download"] forState:UIControlStateNormal];
    }
    [PVSI.modeBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.modeBtn bk_addEventHandler:^(id sender) {
        if (ZYDelegate.playType != 0) {
            [PVSI.modeBtn setBackgroundImage:[UIImage imageNamed:@"icon_shuffleCycle"] forState:UIControlStateNormal];
            [self showMsg:@"顺序播放"];
            ZYDelegate.playType = 0;
        } else {
            [PVSI.modeBtn setBackgroundImage:[UIImage imageNamed:@"icon_singleCycle"] forState:UIControlStateNormal];
            [self showMsg:@"单曲循环"];
            ZYDelegate.playType = 1;
        }
    } forControlEvents:UIControlEventTouchUpInside];
    PVSI.listBtn.hidden = NO;
    //添加播放控制视图
    PVSI.playBtn.selected = YES;
    //锁屏时显示播放界面
    [self showInfoInLockedScreen];
    //设置音量
    self.maxVolume = 5.0;
    PVSI.voiceSlider.value = PVSI.player.volume / self.maxVolume;
    PVSI.voiceSlider.hidden = YES;
}

//滑动slider控件
- (void)moveSlider{
    [PVSI.songSlider bk_removeEventHandlersForControlEvents:UIControlEventTouchDown];
    [PVSI.songSlider bk_addEventHandler:^(UISlider *sender) {
        //按下slider时注销timer计时器
        [PVSI invalidatePlayingTimer];
        NSLog(@"down,%f",PVSI.player.rate);
        if (PVSI.player.rate == 1) {
            self.isPlay = YES;
            [self songPause];
        } else{
            self.isPlay = NO;
        }
    } forControlEvents:UIControlEventTouchDown];
    [PVSI.songSlider bk_removeEventHandlersForControlEvents:UIControlEventValueChanged];
    [PVSI.songSlider bk_addEventHandler:^(UISlider *sender) {
        PVSI.currentTimeLb.text = [self stringByTime:[self timeByInterval:PVSI.totalTimeLb.text] * sender.value];
        NSLog(@"valueChanged:%f",sender.value);
    } forControlEvents:UIControlEventValueChanged];
    
    [PVSI.songSlider bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [PVSI.songSlider bk_addEventHandler:^(UISlider *sender) {
        //松开slider时开启timer计时器
        [PVSI startPlayingTimer];
        NSLog(@"upinside|upoutside:%f",sender.value);
        //调节播放进度
        //CMTimeGetSeconds(self.player.currentTime)
        CMTime dragedCMTime = CMTimeMake([self timeByInterval:PVSI.totalTimeLb.text] * PVSI.songSlider.value, 1);
        [PVSI.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            if(self.isPlay){
                [self songPlay];
            }
            [MPNowPlayingInfoManager solveLockedScreenProgressBarBugWithPlayBackTime:PVSI.player.currentTime];
        }];
    } forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)songPlayDidEnd:(NSNotification *)notification{
    if (ZYDelegate.playType == 0) {//顺序播放
        //自动跳到下一首
        if (PVSI.musicListType == downloadMusicType) {//下载的音乐
            PVSI.playingList = self.downloadArr;
            NSInteger nextIndex = [self indexOfNextSong:[self getIndexOfDSong] WithCount:PVSI.playingList.count];
            PVSI.musicDic = PVSI.playingList[nextIndex];
            NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], PVSI.musicDic[@"song"],@"mp3");
            PVSI.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:musicString]];
        } else {
            if (PVSI.isNetMusicList) {//普通网络音乐
                PVSI.songId = [self indexOfNextSong:PVSI.songId WithCount:PVSI.playingList.count];
                [self dataForNetworkMusic];
            } else {//喜爱的网络音乐
                PVSI.playingList = self.favorArr;
                NSInteger nextIndex = [self indexOfNextSong:[self getIndexOfFSong] WithCount:PVSI.playingList.count];
                [self favorMTapWith:nextIndex];
            }
        }
        [self tabMusicWith:PVSI.nextBtn];
    } else {//单曲循环
        if (PVSI.musicListType == downloadMusicType) {//下载的音乐
            NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], PVSI.musicDic[@"song"],@"mp3");
            PVSI.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:musicString]];
        } else {
            if (PVSI.isNetMusicList) {//普通网络音乐
                [self dataForNetworkMusic];
            } else {//喜爱的网络音乐
                PVSI.playingList = self.favorArr;
                [self favorMTapWith:[self getIndexOfFSong]];
            }
        }
        [self tabMusicWith:PVSI.playBtn];
        
    }
}

//背景和专辑图片准备
- (void)arrangeImgV {
    //NSString *imageString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Image"], PVSI.musicDic[@"song"], PVSI.musicDic[@"album"], @"png");
    NSString *imageString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Image"],PVSI.musicDic[@"song"],@"png");
    //背景图片
    [PVSI.bgImgV setImage:[UIImage imageWithContentsOfFile:imageString]];
    PVSI.albumCoverMaskImgV.hidden = NO;
    //专辑图片
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageString]) {
        [PVSI.albumCoverImgV.imageView setImage:[UIImage imageWithContentsOfFile:imageString]];
    } else {
        [PVSI.albumCoverImgV.imageView setImage:[UIImage imageNamed:@"cell_bg_noData"]];
    }
}

//返回按钮
- (void)showBackBtn {
    //移除观察者
    [PVSI.backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.backBtn bk_addEventHandler:^(id sender) {
        NSLog(@"back");
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
}

//分享按钮
- (void)showShareBtn {
    //移除观察者
    [PVSI.shareBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.shareBtn bk_addEventHandler:^(id sender) {
        //友盟分享调用
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:[NSString stringWithFormat:@"%@-%@,%@",PVSI.musicDic[@"song"],PVSI.musicDic[@"singer"],PVSI.musicDic[@"url"]]
                                         shareImage:[UIImage imageNamed:PVSI.musicDic[@"cover"]]
                                    shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                           delegate:self];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeMusic url:PVSI.musicDic[@"url"]];
    } forControlEvents:UIControlEventTouchUpInside];
}


//点击收藏按钮
- (void)favorBtnTap {
    [PVSI.favorBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.favorBtn bk_addEventHandler:^(id sender) {
        NSLog(@"favor");
        for (BmobObject *obj in self.favorArr) {
            if ([[obj objectForKey:@"songName"] isEqualToString:PVSI.musicDic[@"song"]]) {
                self.fObj = obj;
            }
        }
        if (ZYDelegate.loginOrNot) {
            if (self.likeOrNot) {//已点赞歌曲
                [self.fObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [self.favorArr removeObject:self.fObj];
                        [self showMsg:@"取消收藏"];
                        [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
                        self.likeOrNot = NO;
                    } else if (error) {
                        NSLog(@"取消收藏音乐时失败，原因为%@",error);
                    } else{
                        NSLog(@"取消收藏音乐时失败，原因未知");
                    }
                }];
            } else {//未点赞歌曲
                BmobObject *songFavor = [[BmobObject alloc] initWithClassName:@"ZY_SongFavor"];
                [songFavor setObject:PVSI.musicDic[@"song"] forKey:@"songName"];
                [songFavor setObject:PVSI.musicDic[@"duration"] forKey:@"songDuration"];
                [songFavor setObject:PVSI.musicDic[@"album"] forKey:@"songAlbum"];
                [songFavor setObject:PVSI.musicDic[@"singer"] forKey:@"songSinger"];
                [songFavor setObject:PVSI.musicDic[@"url"]  forKey:@"songUrl"];
                [songFavor setObject:ZYDelegate.userId forKey:@"userId"];
                [songFavor setObject:PVSI.coverImageURL forKey:@"songCover"];
                [songFavor saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
                        [self showMsg:@"收藏成功"];
                        [self.favorArr addObject:songFavor];
                        self.likeOrNot = YES;
                    } else if (error) {
                        NSLog(@"收藏音乐时失败，原因为%@",error);
                    } else{
                        NSLog(@"收藏音乐时失败，原因未知");
                    }
                }];
            }
        } else {
            [self showMsg:@"请先登录"];
        }
    } forControlEvents:UIControlEventTouchUpInside];
}
//点击下载按钮
- (void)downloadBtnTap {
    [PVSI.downloadBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.downloadBtn bk_addEventHandler:^(id sender) {
        if (ZYDelegate.downloadUnderWWAN || ZYDelegate.isOnLine == 2) {
            PVSI.downloadBtn.enabled = NO;
            [self showMsg:@"正在下载"];
            [self.dlmNetManager methodDownloadURL:[NSURL URLWithString:PVSI.musicDic[@"url"]]];
            //图片以png格式保存
            NSString *rootPath = [DirectoriesPath stringByAppendingPathComponent:@"Image"];
            BOOL PNGisSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (PNGisSuccess) {
                NSString *filePath = piece_together(rootPath, PVSI.musicDic[@"song"], @"png");
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:PVSI.coverImageURL]];
                [imageData writeToFile:filePath atomically:YES];
                NSLog(@"下载图片成功");
            }
        } else if (ZYDelegate.isOnLine == 0) {
            [self showMsg:@"下载失败，请检查网络"];
        } else if (ZYDelegate.onLine == 1 && ZYDelegate.downloadUnderWWAN == NO){
            [self showMsg:@"现在您使用的是流量哦,请设置后再下载"];
        }
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapMusic {
    //移除观察者
    [PVSI.nextBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.prevBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.listBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [PVSI.voiceSlider bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    //下一首
    [PVSI.nextBtn bk_addEventHandler:^(id sender) {
        [self gotoNextSong];
    } forControlEvents:UIControlEventTouchUpInside];
    //上一首
    [PVSI.prevBtn bk_addEventHandler:^(id sender) {
        NSLog(@"prev");
        [self gotoPreSong];
    } forControlEvents:UIControlEventTouchUpInside];
    //调节音量
    [PVSI.voiceSlider bk_addEventHandler:^(UISlider *sender) {
        NSLog(@"volume:%f",PVSI.player.volume);
        PVSI.player.volume = sender.value * self.maxVolume;
    } forControlEvents:UIControlEventValueChanged];
    //弹出音量
    [PVSI.listBtn bk_addEventHandler:^(id sender) {
        if (PVSI.voiceSlider.hidden) {
            PVSI.voiceSlider.hidden = NO;
        } else {
            PVSI.voiceSlider.hidden = YES;
        }
    } forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 播放、暂停、上一首、下一首
//播放
- (void)songPlay{
    [PVSI.player play];
}
//暂停
- (void)songPause{
    [PVSI.player pause];
}

//上一首歌
- (void)gotoPreSong{
    if (PVSI.musicListType == downloadMusicType) {
        PVSI.playingList = self.downloadArr;
        NSInteger prevIndex = [self indexOfPrevSong:[self getIndexOfDSong] WithCount:self.downloadArr.count];
        PVSI.musicDic = self.downloadArr[prevIndex];
        NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], PVSI.musicDic[@"song"],@"mp3");
        PVSI.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:musicString]];
    } else {
        if (PVSI.isNetMusicList) {//网络音乐
            PVSI.songId = [self indexOfPrevSong:PVSI.songId WithCount:PVSI.playingList.count];
            [self dataForNetworkMusic];
        } else {//喜爱的音乐
            PVSI.playingList = self.favorArr;
            NSInteger prevIndex = [self indexOfPrevSong:[self getIndexOfFSong] WithCount:self.favorArr.count];
            [self favorMTapWith:prevIndex];
        }
    }
    [self tabMusicWith:PVSI.prevBtn];
}
//下一首歌
- (void)gotoNextSong{
    if (PVSI.musicListType == downloadMusicType) {//下载的音乐
        PVSI.playingList = self.downloadArr;
        NSInteger nextIndex = [self indexOfNextSong:[self getIndexOfDSong] WithCount:PVSI.playingList.count];
        PVSI.musicDic = PVSI.playingList[nextIndex];
        NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], PVSI.musicDic[@"song"], @"mp3");
        PVSI.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:musicString]];
    } else {
        if (PVSI.isNetMusicList) {//普通网络音乐
            PVSI.songId = [self indexOfNextSong:PVSI.songId WithCount:PVSI.playingList.count];
            [self dataForNetworkMusic];
        } else {//喜爱的网络音乐
            PVSI.playingList = self.favorArr;
            NSInteger nextIndex = [self indexOfNextSong:[self getIndexOfFSong] WithCount:PVSI.playingList.count];
            [self favorMTapWith:nextIndex];
        }
    }
    [self tabMusicWith:PVSI.nextBtn];
}

#pragma mark - 准备工作

//网络音乐切换前的数据准备
- (void)dataForNetworkMusic {
    NSDictionary *dic = PVSI.playingList[PVSI.songId];
    [PlayView sharedInstance].musicDic = dic;
    PVSI.player = [AVPlayer playerWithURL:[NSURL URLWithString:dic[@"url"]]];
    PVSI.coverImageURL = dic[@"cover"];
}

//点击网络音乐切换后的工作
- (void)tabMusicWith:(UIButton *)btn {
    [self songPlay];
    [PVSI.albumCoverImgV rotation:15];
    [self viewDidLoad];
}

//获得下一首歌的id
- (NSInteger)indexOfNextSong:(NSInteger)currentIndex WithCount:(NSInteger)count {
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex == count) {
        nextIndex = 0;
    }
    return nextIndex;
}

//获得上一首歌的id
- (NSInteger)indexOfPrevSong:(NSInteger)currentIndex WithCount:(NSInteger)count {
    NSInteger prevIndex = currentIndex - 1;
    if (prevIndex == -1) {
        prevIndex = count - 1;
    }
    return prevIndex;
}

//获得下载的音乐的index
- (NSInteger)getIndexOfDSong {
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.downloadArr.count; i++) {
        if ([self.downloadArr[i][@"song"] isEqualToString:PVSI.musicDic[@"song"]]) {
            index = i;
        }
    }
    return index;
}

//获得喜爱的音乐的index
- (NSInteger)getIndexOfFSong {
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.favorArr.count; i++) {
        if ([[self.favorArr[i] objectForKey:@"songName"] isEqualToString:PVSI.musicDic[@"song"]]) {
            index = i;
        }
    }
    return index;
}

- (void)favorMTapWith:(NSInteger)index {
    BmobObject *nextS = self.favorArr[index];
    PVSI.musicDic = @{@"song":[nextS objectForKey:@"songName"],@"duration":[nextS objectForKey:@"songDuration"],@"singer":[nextS objectForKey:@"songSinger"],@"album":[nextS objectForKey:@"songAlbum"],@"url": [nextS objectForKey:@"songUrl"]};
    if (self.downloadOrNot == NO) {//网络音乐
        PVSI.player = [AVPlayer playerWithURL:[NSURL URLWithString:[nextS objectForKey:@"songUrl"]]];
        PVSI.coverImageURL = [nextS objectForKey:@"songCover"];
    } else {//下载的音乐
        NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], PVSI.musicDic[@"song"],@"mp3");
        PVSI.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:musicString]];
        //        PVSI.coverImageURL = nil;
    }
}

//判断此歌是否下载过
- (void)judgeDownload {
    self.downloadOrNot = NO;
    for (NSDictionary *dic in self.downloadArr) {
        if ([dic[@"song"] isEqualToString:PVSI.musicDic[@"song"]]) {
            self.downloadOrNot = YES;
        }
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:{
                [MPNowPlayingInfoManager solveLockedScreenProgressBarBugWithPlayBackTime:PVSI.player.currentTime];
                [self songPlay];
                NSLog(@"play");
                break;
            }
            case UIEventSubtypeRemoteControlPause:
                [self songPause];
                NSLog(@"pause");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self gotoPreSong];
                NSLog(@"track");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self gotoNextSong];
                NSLog(@"nextItem");
                break;
            default:
                break;
        }
        PVSI.playBtn.selected = PVSI.player.rate;
    }
}

#pragma mark - 锁屏显歌词
// 在锁屏界面显示歌曲信息
- (void)showInfoInLockedScreen{
    NSLog(@"1:%@,2:%@",PVSI.coverImageURL,PVSI.musicDic[@"cover"]);
    //    http://fdfs.xmcdn.com/group13/M09/0B/59/wKgDXVbNQg2SYh1cAAKX6bF2ZbU798_mobile_large.jpg
    if (PVSI.musicListType == downloadMusicType) {
        _artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:PVSI.musicDic[@"cover"]]]]];
    } else {
        _artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:PVSI.coverImageURL]]]];
    }
    NSDictionary *info = @{
                           MPMediaItemPropertyTitle:PVSI.musicDic[@"song"],
                           MPMediaItemPropertyArtist:PVSI.musicDic[@"singer"],
                           MPMediaItemPropertyArtwork:_artWork,
                           MPNowPlayingInfoPropertyElapsedPlaybackTime:[NSNumber numberWithDouble:CMTimeGetSeconds(PVSI.player.currentTime)],
                           MPNowPlayingInfoPropertyPlaybackRate:[NSNumber numberWithFloat:1.0],
                           MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithFloat:[self timeByInterval:PVSI.musicDic[@"duration"]]]
                           };
    [MPNowPlayingInfoManager showInfoInLockedScreenWithInfo:info];
}

#pragma mark - Delegate
- (void)tellyouProgress:(CGFloat)progress {
    if (progress >= 1) {
        [self receiveProgress];
    }
}
- (void)tellyouLocation:(NSURL *)location{
    //音乐以MP3格式保存
    NSString *MP3savaFileName = [PVSI.musicDic[@"song"] stringByAppendingPathExtension:@"mp3"];
    NSString *MP3rootPath = [DirectoriesPath stringByAppendingPathComponent:@"Music"];
    BOOL MP3isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:MP3rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (MP3isSuccess) {
        NSString *filePath = [MP3rootPath stringByAppendingPathComponent:MP3savaFileName];
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
    }
}

- (void)receiveProgress {
    [self showSuccessMsg:@"下载完成"];
    [PVSI.downloadBtn setBackgroundImage:[UIImage imageNamed:@"icon_downloaded"] forState:UIControlStateDisabled];
    NSString *songDownloadPlistPath = [DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:songDownloadPlistPath];
    NSDictionary *dic = @{@"song":PVSI.musicDic[@"song"],@"duration":PVSI.musicDic[@"duration"],@"singer":PVSI.musicDic[@"singer"],@"album":PVSI.musicDic[@"album"],@"time":[self dateForStandardYMdHmsS],@"url": PVSI.musicDic[@"url"],@"cover":PVSI.coverImageURL};
    [array addObject:dic];
    [array writeToFile:songDownloadPlistPath atomically:YES];
    [self.downloadArr addObject:dic];
}

@end
