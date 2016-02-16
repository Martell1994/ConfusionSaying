//
//  NewsNetManager.m
//  子曰
//
//  Created by Martell on 16/1/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsNetManager.h"

@implementation NewsNetManager
+ (id)getNewsBySize:(NSInteger)size CompletionHandle:(void (^)(NewsModel *, NSError *))completionHandle{
    NSString *path = [NSString stringWithFormat:@"http://c.m.163.com//nc/article/headline/T1348647853363/%ld-10.html",size];
//    DDLogVerbose(@"%@",path);
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([NewsModel mj_objectWithKeyValues:responseObj],error);
    }];
}
+ (id)getNewsPhotoByUrlString:(NSString *)UrlString CompletionHandle:(void (^)(NewsPhotoModel *, NSError *))completionHandle{
    // 取出关键字
    NSString *one  = UrlString;
    NSString *two = [one substringFromIndex:4];
    NSArray *finalStr = [two componentsSeparatedByString:@"|"];
    NSString *path = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json",finalStr[0],finalStr[1]];
    NSLog(@"%@",path);
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([NewsPhotoModel mj_objectWithKeyValues:responseObj],error);
    }];
}
+ (id)getNewsHtmlByDocId:(NSString *)docId CompletionHandle:(void(^)(NewsHtmlModel *model,NSError *error))completionHandle{
    NSString *path = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",docId];
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([NewsHtmlModel mj_objectWithKeyValues:responseObj[docId]],error);
    }];
}
@end
