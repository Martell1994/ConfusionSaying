
//
//  NewsPhotoViewModel.m
//  子曰
//
//  Created by Martell on 16/1/24.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsPhotoViewModel.h"

@implementation NewsPhotoViewModel
- (NSInteger)rowNum{
    return self.newsPhotoArr.count;
}
- (NSMutableArray *)newsPhotoArr{
    if (!_newsPhotoArr) {
        _newsPhotoArr = [NSMutableArray new];
    }
    return _newsPhotoArr;
}

- (NewsPhotosModel *)newsPhotosModelForRow:(NSInteger)row{
    return self.newsPhotoArr[row];
}
- (NSURL *)imgurlForRow:(NSInteger)row{
    return [NSURL URLWithString:[self newsPhotosModelForRow:row].imgurl];
}
- (NSString *)noteForRow:(NSInteger)row{
    return [self newsPhotosModelForRow:row].note;
}

- (NSString *)url {
    return self.newsPhotoModel.url;
}

- (NSURL *)cover {
    return [NSURL URLWithString:self.newsPhotoModel.cover];
}

- (NSString *)setname{
    return self.newsPhotoModel.setname;
}
- (void)getDatabByUrlString:(NSString *)UrlString CompleteHandle:(void (^)(NSError *error))complete{
    [NewsNetManager getNewsPhotoByUrlString:UrlString CompletionHandle:^(NewsPhotoModel *model, NSError *error) {
        self.newsPhotoModel = model;
        [self.newsPhotoArr removeAllObjects];
        [self.newsPhotoArr addObjectsFromArray:model.photos];
        complete(error);
    }];
}
- (void)refreshDataByUrlString:(NSString *)UrlString CompleteHandle:(void (^)(NSError *error))complete{
    [self getDatabByUrlString:UrlString CompleteHandle:complete];
}

@end
