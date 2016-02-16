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
#define PVSI [PlayView sharedInstance]

@interface PlayViewController ()
@property (nonatomic, copy) NSString *songDownloadPlistPath;
@property (nonatomic, copy) NSString *songObjId;
@property (nonatomic, assign) BOOL likeOrNot;
@property (nonatomic, strong) AppDelegate *delegate;
@end

@implementation PlayViewController

- (NSString *)songDownloadPlistPath {
    if (!_songDownloadPlistPath) {
        _songDownloadPlistPath = [DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"];
    }
    return _songDownloadPlistPath;
}

- (AppDelegate *)delegate {
    if (!_delegate) {
        _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _delegate;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [PVSI.favorBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self viewInit];
    //将播放界面加入VC中
    [self.view addSubview:PVSI];
    [PVSI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewInit {
    NSMutableArray *downloadArr = [NSMutableArray arrayWithContentsOfFile:self.songDownloadPlistPath];
    if (self.musicListType == downloadMusicType) {
        NSString *imageString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Image"], PVSI.musicDic[@"song"], PVSI.musicDic[@"album"], @"png");
        //背景图片
        [PVSI.bgImgV setImage:[UIImage imageWithContentsOfFile:imageString]];
        PVSI.albumCoverMaskImgV.hidden = NO;
        //专辑图片
        if ([[NSFileManager defaultManager] fileExistsAtPath:imageString]) {
            [PVSI.albumCoverImgV.imageView setImage:[UIImage imageWithContentsOfFile:imageString]];
        } else {
            [PVSI.albumCoverImgV.imageView setImage:[UIImage imageNamed:@"cell_bg_noData"]];
        }
    } else {
        //背景图片
        [PVSI.bgImgV sd_setImageWithURL:[NSURL URLWithString:PVSI.coverImageURL] placeholderImage:[UIImage imageNamed:@"cell_bg_noData"]];
        //专辑图片
        PVSI.albumCoverMaskImgV.hidden = NO;
        [PVSI.albumCoverImgV.imageView sd_setImageWithURL:[NSURL URLWithString:PVSI.coverImageURL] placeholderImage:[UIImage imageNamed:@"cell_bg_noData"]];
    }
    //返回按钮
    [PVSI.backBtn bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    //收藏按钮
    [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    if (self.delegate.loginOrNot) {
        BmobQuery *bquery = [BmobQuery new];
        NSString *selectSql = [NSString stringWithFormat:@"select *from ZY_SongFavor where songName = '%@' and userId = '%@'",PVSI.musicDic[@"song"], self.delegate.userId];
        [bquery queryInBackgroundWithBQL:selectSql block:^(BQLQueryResult *result, NSError *error) {
            if (result.resultsAry.count) {
                [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
                self.likeOrNot = YES;
                self.songObjId = [result.resultsAry[0] objectForKey:@"objectId"];
            }
        }];
    }
    [PVSI.favorBtn bk_addEventHandler:^(id sender) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.loginOrNot) {
            if (self.likeOrNot) {
                BmobObject *cancelObject = [BmobObject objectWithoutDatatWithClassName:@"ZY_SongFavor" objectId:self.songObjId];
                [cancelObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [self showMsg:@"取消收藏" OnView:PVSI];
                        [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
                        self.likeOrNot = NO;
                    } else if (error) {
                        NSLog(@"取消收藏音乐时失败，原因为%@",error);
                    } else{
                        NSLog(@"取消收藏音乐时失败，原因未知");
                    }
                }];
            } else {
                BmobObject *songFavor = [[BmobObject alloc] initWithClassName:@"ZY_SongFavor"];
                [songFavor setObject:PVSI.musicDic[@"song"] forKey:@"songName"];
                [songFavor setObject:PVSI.musicDic[@"duration"] forKey:@"songDuration"];
                [songFavor setObject:PVSI.musicDic[@"album"] forKey:@"songAlbum"];
                [songFavor setObject:PVSI.musicDic[@"singer"] forKey:@"songSinger"];
                [songFavor setObject:PVSI.musicDic[@"url"]  forKey:@"songUrl"];
                [songFavor setObject:self.delegate.userId forKey:@"userId"];
                [songFavor setObject:PVSI.coverImageURL forKey:@"songCover"];
                [songFavor saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [PVSI.favorBtn setBackgroundImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateNormal];
                        [self showMsg:@"收藏成功" OnView:PVSI];
                        self.likeOrNot = YES;
                    } else if (error) {
                        NSLog(@"收藏音乐时失败，原因为%@",error);
                    } else{
                        NSLog(@"收藏音乐时失败，原因未知");
                    }
                }];
            }
        } else {
            [self showSuccessMsg:@"请先登录"];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    //歌曲名
    PVSI.songSV.hidden = NO;
    //专辑名
    PVSI.albumSV.hidden = NO;
    //进度条
    PVSI.songProgress.progress = 0;
    //现在播放时间
    PVSI.currentTimeLb.hidden = NO;
    //音乐时长
    PVSI.totalTimeLb.text = PVSI.musicDic[@"duration"];
    //四个按钮
    [PVSI.shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [PVSI.downloadBtn setBackgroundImage:[UIImage imageNamed:@"icon_download"] forState:UIControlStateNormal];
    PVSI.modeBtn.hidden = NO;
    PVSI.listBtn.hidden = NO;
    //添加播放控制视图
    PVSI.playBtn.selected = YES;
    //下一首
    NSArray *listPlaying = [NSArray arrayWithContentsOfFile:self.songDownloadPlistPath];
    [PVSI.nextBtn bk_addEventHandler:^(id sender) {
        if (self.musicListType == downloadMusicType) {
            NSInteger nextIndex = [self indexOfNextSong:[self getIndexOfSong] WithCount:downloadArr.count];
            PVSI.musicDic = listPlaying[nextIndex];
            NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], PVSI.musicDic[@"song"], PVSI.musicDic[@"album"], @"mp3");
            PVSI.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:musicString]];
        } else {
            self.songId = [self indexOfNextSong:self.songId WithCount:self.musicVM.rowNumber];
            [self dataForNetworkMusic];
        }
        [self tabMusicWith:PVSI.nextBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    //上一首
    [PVSI.prevBtn bk_addEventHandler:^(id sender) {
        if (self.musicListType == downloadMusicType) {
            NSInteger prevIndex = [self indexOfPrevSong:[self getIndexOfSong] WithCount:downloadArr.count];
            PVSI.musicDic = listPlaying[prevIndex];
            NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], PVSI.musicDic[@"song"], PVSI.musicDic[@"album"], @"mp3");
            PVSI.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:musicString]];
        } else {
            self.songId = [self indexOfPrevSong:self.songId WithCount:self.musicVM.rowNumber];
            [self dataForNetworkMusic];
        }
        [self tabMusicWith:PVSI.prevBtn];
    } forControlEvents:UIControlEventTouchUpInside];
}

//网络音乐切换前的数据准备
- (void)dataForNetworkMusic {
    [PlayView sharedInstance].coverImageURL = [self.musicVM largeCoverURLForRow:self.songId];
    NSDictionary *dic = @{@"song":[self.musicVM titleForRow:self.songId],@"duration":[self.musicVM durationForRow:self.songId],@"singer":[self.musicVM sourceForRow:self.songId],@"album":self.album,@"url": [self.musicVM musicURLForRow:self.songId]};
    [PlayView sharedInstance].musicDic = dic;
    PVSI.player = [AVPlayer playerWithURL:[NSURL URLWithString:[self.musicVM musicURLForRow:self.songId]]];
}

//点击网络音乐切换后的工作
- (void)tabMusicWith:(UIButton *)btn {
    [PVSI.player play];
    [PVSI.albumCoverImgV rotation:15];
    [btn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
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

- (NSInteger)getIndexOfSong {
    NSArray *songArr = [NSArray arrayWithContentsOfFile:self.songDownloadPlistPath];
    NSInteger index = -1;
    for (NSInteger i = 0; i < songArr.count; i++) {
        if ([songArr[i][@"song"] isEqualToString:PVSI.musicDic[@"song"]]) {
            index = i;
        }
    }
    return index;
}


@end
