//
//  NewsPhotoModel.m
//  子曰
//
//  Created by Martell on 16/1/24.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsPhotoModel.h"

@implementation NewsPhotoModel


+ (NSDictionary *)objectClassInArray{
    return @{@"photos" : [NewsPhotosModel class]};
}
@end

@implementation NewsPhotosModel

@end


