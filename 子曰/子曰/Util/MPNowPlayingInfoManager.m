//
//  MPNowPlayingInfoManager.m
//  子曰
//
//  Created by Martell on 16/2/22.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "MPNowPlayingInfoManager.h"

@implementation MPNowPlayingInfoManager
+ (void)showInfoInLockedScreenWithInfo:(NSDictionary *)info{
    // 健壮性写法
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    }
}
+ (void)solveLockedScreenProgressBarBugWithPlayBackTime:(CMTime)backTime{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    [dict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(backTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}
@end
