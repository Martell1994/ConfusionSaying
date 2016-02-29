//
//  MusicViewModel.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicViewModel.h"
#import "MusicNetManager.h"

@implementation MusicViewModel
- (NSInteger)rowNumber {
    return self.dataArr.count;
}

- (BOOL)isHasMore {
    return _maxPageId > _pageId;
}

- (void)refreshDataCompletionHandle:(CompletionHandle)completionHandle {
    _pageId = 1;
    [self getDataFromNetCompleteHandle:completionHandle];
}

- (void)getMoreDataCompletionHandle:(CompletionHandle)completionHandle {
    if (self.isHasMore) {
        _pageId += 1;
        [self getDataFromNetCompleteHandle:completionHandle];
    } else {
        NSError *error = [NSError errorWithDomain:@"" code:999 userInfo:@{NSLocalizedDescriptionKey:@"没有更多数据"}];
        completionHandle(error);
    }
}

- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle {
    self.dataTask = [MusicNetManager getAlbumWithId:_albumId page:_pageId completionHandle:^(AlbumModel *model, NSError *error) {
        if (_pageId == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:model.tracks.list];
        _maxPageId = model.tracks.maxPageId;
        completionHandle(error);
    }];
}

- (instancetype)initWithAlbumId:(NSInteger)albumId {
    if (self = [super init]) {
        self.albumId = albumId;
    }
    return self;
}

- (AlbumTracksListModel *)modelForRow:(NSInteger)row {
    return self.dataArr[row];
}

- (NSURL *)coverURLForRow:(NSInteger)row {
    return [NSURL URLWithString:[self modelForRow:row].coverSmall];
}

- (NSString *)largeCoverURLForRow:(NSInteger)row {
    return [self modelForRow:row].coverLarge;
}

- (NSString *)titleForRow:(NSInteger)row {
    return [self modelForRow:row].title;
}

- (NSString *)timeForRow:(NSInteger)row {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval delta = currentTime - [self modelForRow:row].createdAt / 1000;
    NSInteger hours = delta / 3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    NSInteger days = delta / 3600 / 24;
    return [NSString stringWithFormat:@"%ld天前",days];
    
}

- (NSString *)sourceForRow:(NSInteger)row {
    return [self modelForRow:row].nickname;
}

- (NSString *)playCountForRow:(NSInteger)row {
    NSInteger count = [self modelForRow:row].playtimes;
    if (count < 10000) {
        return @([self modelForRow:row].playtimes).stringValue;
    } else {
        return [NSString stringWithFormat:@"%.1f万",[self modelForRow:row].playtimes / 10000.0];
    }
}

- (NSString *)favorCountForRow:(NSInteger)row {
    return @([self modelForRow:row].likes).stringValue;
}

- (NSString *)commentCountForRow:(NSInteger)row {
    return @([self modelForRow:row].comments).stringValue;
}

- (NSString *)durationForRow:(NSInteger)row {
    NSInteger duration = [self modelForRow:row].duration;
    return [NSString stringWithFormat:@"%02ld:%02ld",duration / 60, duration % 60];
}

- (NSURL *)downLoadURLForRow:(NSInteger)row {
    return [NSURL URLWithString:[self modelForRow:row].downloadUrl];
}

- (NSString *)musicURLForRow:(NSInteger)row {
    return [self modelForRow:row].playUrl64;
}

@end
