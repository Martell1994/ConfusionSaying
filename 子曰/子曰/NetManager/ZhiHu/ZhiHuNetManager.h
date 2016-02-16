//
//  ZhiHuNetManager.h
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseNetManager.h"
#import "ZhiHuMainModel.h"
#import "ZhiHuCategoryModel.h"
#import "ZhiHuHtmlModel.h"
#import "ZhiHuCateDetailModel.h"

@interface ZhiHuNetManager : BaseNetManager

+ (id)getZhiHuCompletionHandle:(void(^)(ZhiHuMainModel *model,NSError *error))completionHandle;

+ (id)getZhiHuHtmlByStoryId:(NSInteger)storyId CompletionHandle:(void(^)(ZhiHuHtmlModel *model,NSError *error))completionHandle;

+ (id)getZhiHuCategoryCompletionHandle:(void(^)(ZhiHuCategoryModel *model,NSError *error))completionHandle;

+ (id)getZhiHuCateDetailByCateId:(NSInteger)cateId CompletionHandle:(void(^)(ZhiHuCateDetailModel *model,NSError *error))completionHandle;
@end
