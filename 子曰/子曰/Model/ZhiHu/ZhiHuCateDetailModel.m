//
//  ZhiHuCateDetailModel.m
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuCateDetailModel.h"

@implementation ZhiHuCateDetailModel
+ (NSDictionary *)objectClassInArray{
    return @{@"stories" : [ZhiHuCateDetailStoriesModel class], @"editors" : [ZhiHuCateDetailEditorsModel class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"desc" : @"description"};
}
@end
@implementation ZhiHuCateDetailStoriesModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"story_id" : @"id"};
}
@end


@implementation ZhiHuCateDetailEditorsModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"cateEditorsId" : @"id"};
}
@end


