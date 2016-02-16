//
//  NewsModel.m
//  子曰
//
//  Created by Martell on 16/1/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"T1348647853363" : [NewsTModel class]};
}

@end
@implementation NewsTModel

+ (NSDictionary *)objectClassInArray{
    return @{@"ads" : [NewsAdsModel class], @"imgextra" : [NewsImgextraModel class]};
}

@end


@implementation NewsAdsModel

@end

@implementation NewsImgextraModel

@end

