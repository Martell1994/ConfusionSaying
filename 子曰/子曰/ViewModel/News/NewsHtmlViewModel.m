//
//  NewsHtmlViewModel.m
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsHtmlViewModel.h"

@implementation NewsHtmlViewModel
- (NSInteger)imgRowNum{
    return self.newsHtmlImgArr.count;
}
- (NSMutableArray *)newsHtmlImgArr{
    if (!_newsHtmlImgArr) {
        _newsHtmlImgArr = [NSMutableArray new];
    }
    return _newsHtmlImgArr;
}

- (NewsHtmlImgModel *)newsHtmlModelForRow:(NSInteger)row{
    return self.newsHtmlImgArr[row];
}

- (NSString *)pixelForRow:(NSInteger)row{
    return [self newsHtmlModelForRow:row].pixel;
}

- (NSString *)refForRow:(NSInteger)row{
    return [self newsHtmlModelForRow:row].ref;
}

- (NSString *)srcForRow:(NSInteger)row{
    return [self newsHtmlModelForRow:row].src;
}

- (NSString *)title{
    return self.newsHtmlModel.title;
}

- (NSString *)sourceUrl {
    return self.newsHtmlModel.source_url;
}

- (NSString *)body{
    return self.newsHtmlModel.body;
}

- (NSString *)ptime{
    return self.newsHtmlModel.ptime;
}

- (void)getDataByDocId:(NSString *)docId CompleteHandle:(void (^)(NSError *error))complete{
    [NewsNetManager getNewsHtmlByDocId:docId CompletionHandle:^(NewsHtmlModel *model, NSError *error) {
        [self.newsHtmlImgArr removeAllObjects];
        [self.newsHtmlImgArr addObjectsFromArray:model.img];
        self.newsHtmlModel = model;
        complete(error);
    }];
}
- (void)refreshDataByDocId:(NSString *)docId CompleteHandle:(void (^)(NSError *error))complete{
    [self getDataByDocId:docId CompleteHandle:complete];
}

@end
