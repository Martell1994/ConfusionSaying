//
//  NewsNetManager.h
//  子曰
//
//  Created by Martell on 16/1/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseNetManager.h"
#import "NewsModel.h"
#import "NewsPhotoModel.h"
#import "NewsHtmlModel.h"

@interface NewsNetManager : BaseNetManager
+ (id)getNewsBySize:(NSInteger)Size CompletionHandle:(void(^)(NewsModel *model,NSError *error))completionHandle;

+ (id)getNewsPhotoByUrlString:(NSString *)UrlString CompletionHandle:(void(^)(NewsPhotoModel *model,NSError *error))completionHandle;

+ (id)getNewsHtmlByDocId:(NSString *)docId CompletionHandle:(void(^)(NewsHtmlModel *model,NSError *error))completionHandle;
@end
