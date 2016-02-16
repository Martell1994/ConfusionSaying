//
//  ZhiHuCategoryModel.m
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuCategoryModel.h"

@implementation ZhiHuCategoryModel


+ (NSDictionary *)objectClassInArray{
    return @{@"others" : [ZhiHuOthersModel class]};
}
@end
@implementation ZhiHuOthersModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"cate_id" : @"id", @"desc" : @"description"};
}
@end


