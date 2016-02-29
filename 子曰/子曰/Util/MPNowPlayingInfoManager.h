//
//  MPNowPlayingInfoManager.h
//  子曰
//
//  Created by Martell on 16/2/22.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MPNowPlayingInfoManager : NSObject
/* 
 * 在锁屏界面显示歌曲信息
 */
+ (void)showInfoInLockedScreenWithInfo:(NSDictionary *)info;

/*
 * 解决锁屏状态从暂停切换到播放时进度条跳跃的问题
 */
+ (void)solveLockedScreenProgressBarBugWithPlayBackTime:(CMTime)backTime;
@end
