//
//  ZhiHuNetManager.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuNetManager.h"

@implementation ZhiHuNetManager
+ (id)getZhiHuCompletionHandle:(void (^)(ZhiHuMainModel *, NSError *))completionHandle{
    NSString *path = @"http://news-at.zhihu.com/api/4/news/latest";
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([ZhiHuMainModel mj_objectWithKeyValues:responseObj],error);
    }];
}
+ (id)getZhiHuHtmlByStoryId:(NSInteger)storyId CompletionHandle:(void(^)(ZhiHuHtmlModel *model,NSError *error))completionHandle{
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%ld",storyId];
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([ZhiHuHtmlModel mj_objectWithKeyValues:responseObj],error);
    }];
}
+ (id)getZhiHuCategoryCompletionHandle:(void (^)(ZhiHuCategoryModel *, NSError *))completionHandle{
    NSString *path = @"http://news-at.zhihu.com/api/4/themes";
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([ZhiHuCategoryModel mj_objectWithKeyValues:responseObj],error);
    }];
}
+ (id)getZhiHuCateDetailByCateId:(NSInteger)cateId CompletionHandle:(void(^)(ZhiHuCateDetailModel *model,NSError *error))completionHandle{
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%ld",cateId];
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([ZhiHuCateDetailModel mj_objectWithKeyValues:responseObj],error);
    }];

}
@end
