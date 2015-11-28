//
//  MusicNetManager.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicNetManager.h"

#define kRankListPath       @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/album"
#define kAlbumPath          @"http://mobile.ximalaya.com/mobile/others/ca/album/track/%@/true/%@/20"

@implementation MusicNetManager

+ (id)getRankListWithPageId:(NSInteger)pageId completionHandle:(void (^)(id, NSError *))completionHandle{
    //只能使用单独传参方式。  使用地址+参数字符串 会导致程序崩溃!
    NSDictionary *params = @{@"device":@"iPhone", @"key":@"ranking:album:played:1:2", @"pageId":@(pageId), @"pageSize": @20, @"position": @0, @"title": @"排行榜"};
    return [self GET:kRankListPath parameters:params completionHandler:^(id responseObj, NSError *error) {
        completionHandle([RankListModel mj_objectWithKeyValues:responseObj], error);
    }];
}

+ (id)getAlbumWithId:(NSInteger)ID page:(NSInteger)pageId completionHandle:(void (^)(id, NSError *))completionHandle{
    //  %@  已经拼入 宏定义 kAlbumPath 中
    NSString *path = [NSString stringWithFormat:kAlbumPath, @(ID), @(pageId)];
    return [self GET:path parameters:@{@"device": @"iPhone"} completionHandler:^(id responseObj, NSError *error) {
        completionHandle([AlbumModel mj_objectWithKeyValues:responseObj], error);
    }];
}
@end
