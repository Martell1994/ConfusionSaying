//
//  ZhiHuModel.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuMainModel.h"

@implementation ZhiHuMainModel

+ (NSDictionary *)objectClassInArray{
    return @{@"stories" : [ZhiHuStoriesModel class], @"top_stories" : [ZhiHuTop_StoriesModel class]};
}
@end

@implementation ZhiHuStoriesModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"story_id" : @"id"};
}
@end

@implementation ZhiHuTop_StoriesModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"story_id" : @"id"};
}
@end



