//
//  AlbumModel.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

@end


@implementation AlbumAlbumModel

@end


@implementation AlbumTracksModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [AlbumTracksListModel class]};
}

@end


@implementation AlbumTracksListModel

@end
