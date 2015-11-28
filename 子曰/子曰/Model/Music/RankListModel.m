//
//  RankListModel.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "RankListModel.h"

@implementation RankListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [RankListListModel class]};
}
@end

@implementation RankListListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID": @"id"};
}

@end
