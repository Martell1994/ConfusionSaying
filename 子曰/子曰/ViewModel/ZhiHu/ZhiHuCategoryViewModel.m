//
//  ZhiHuCategoryViewModel.m
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuCategoryViewModel.h"

@implementation ZhiHuCategoryViewModel
- (NSInteger)rowNum{
    return self.zhCateArr.count;
}

- (NSMutableArray *)zhCateArr{
    if (!_zhCateArr) {
        _zhCateArr = [NSMutableArray new];
    }
    return _zhCateArr;
}

- (ZhiHuOthersModel *)zhCateModelForRow:(NSInteger)row{
    return self.zhCateArr[row];
}

- (NSInteger)colorForRow:(NSInteger)row{
    return [self zhCateModelForRow:row].color;
}
- (NSString *)descForRow:(NSInteger)row{
    return [self zhCateModelForRow:row].desc;
}
- (NSInteger)cateIdForRow:(NSInteger)row{
    return [self zhCateModelForRow:row].cate_id;
}
- (NSString *)nameForRow:(NSInteger)row{
    return [self zhCateModelForRow:row].name;
}
- (NSURL *)thumbnailForRow:(NSInteger)row{
    return [NSURL URLWithString:[self zhCateModelForRow:row].thumbnail];
}

- (void)getDataCompleteHandle:(void (^)(NSError *error))complete{
    [ZhiHuNetManager getZhiHuCategoryCompletionHandle:^(ZhiHuCategoryModel *model, NSError *error) {
        [self.zhCateArr removeAllObjects];
        [self.zhCateArr addObjectsFromArray:model.others];
        complete(error);
    }];
}
- (void)refreshDataCompleteHandle:(void (^)(NSError *error))complete{
    [self getDataCompleteHandle:complete];
}
@end
