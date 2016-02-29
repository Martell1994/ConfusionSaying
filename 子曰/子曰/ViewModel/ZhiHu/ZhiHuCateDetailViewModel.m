//
//  ZhiHuCateDetailViewModel.m
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuCateDetailViewModel.h"

@implementation ZhiHuCateDetailViewModel
- (NSInteger)rowNum{
    return self.zhCDArr.count;
}

- (NSMutableArray *)zhCDArr{
    if (!_zhCDArr) {
        _zhCDArr = [NSMutableArray new];
    }
    return _zhCDArr;
}

- (ZhiHuCateDetailStoriesModel *)zhCateDSModelForRow:(NSInteger)row{
    return self.zhCDArr[row];
}

- (NSInteger)storyIdForRow:(NSInteger)row{
    return [self zhCateDSModelForRow:row].story_id;
}
- (NSURL *)imageForRow:(NSInteger)row{
    return [NSURL URLWithString:[self zhCateDSModelForRow:row].images[0]];
}

- (NSString *)titleForRow:(NSInteger)row{
    return [self zhCateDSModelForRow:row].title;
}

- (NSInteger)typeForRow:(NSInteger)row{
    return [self zhCateDSModelForRow:row].type;
}

- (NSString *)name{
    return self.zhCDModel.name;
}

- (NSURL *)imageUrl{
    return [NSURL URLWithString:self.zhCDModel.image];
}

- (void)getDataByCateId:(NSInteger)cateId CompleteHandle:(void (^)(NSError *error))complete{
    [ZhiHuNetManager getZhiHuCateDetailByCateId:cateId CompletionHandle:^(ZhiHuCateDetailModel *model, NSError *error) {
        [self.zhCDArr removeAllObjects];
        [self.zhCDArr addObjectsFromArray:model.stories];
        self.zhCDModel = model;
        complete(error);
    }];
}

- (void)refreshDataByCateId:(NSInteger)cateId CompleteHandle:(void (^)(NSError *error))complete{
    [self getDataByCateId:cateId CompleteHandle:complete];
}
@end
