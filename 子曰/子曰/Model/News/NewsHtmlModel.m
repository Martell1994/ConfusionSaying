//
//  NewsHtmlModel.m
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsHtmlModel.h"

@implementation NewsHtmlModel
+ (NSDictionary *)objectClassInArray{
    return @{@"img" : [NewsHtmlImgModel class], @"keyword_search" : [NewsKeyword_SearchModel class], @"relative_sys" : [NewsRelative_SysModel class]};
}

@end

@implementation NewsHtmlImgModel

@end


@implementation NewsKeyword_SearchModel

@end


@implementation NewsRelative_SysModel

@end
