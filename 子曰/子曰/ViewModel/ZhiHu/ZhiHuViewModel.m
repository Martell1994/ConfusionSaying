//
//  ZhiHuViewModel.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuViewModel.h"

@implementation ZhiHuViewModel
/**
 * 滚动视图以上位置
 */
- (NSInteger)rowTopNum{
    return self.zhTopArr.count;
}

- (NSMutableArray *)zhTopArr{
    if (!_zhTopArr) {
        _zhTopArr = [NSMutableArray new];
    }
    return _zhTopArr;
}

- (ZhiHuTop_StoriesModel *)zhTopModelForRow:(NSInteger)row{
    if (self.zhTopArr.count - 1 >= row) {
        return self.zhTopArr[row];
    }else{
        NSLog(@"图片数组出错啦～");
        return nil;
    }
}

- (NSString *)ga_prefixTopForRow:(NSInteger)row{
    return [self zhTopModelForRow:row].ga_prefix;
}
- (NSInteger)story_idTopForRow:(NSInteger)row{
    return [self zhTopModelForRow:row].story_id;
}
- (NSURL *)imageTopForRow:(NSInteger)row{
    return [NSURL URLWithString:[self zhTopModelForRow:row].image];
}
- (NSString *)titleTopForRow:(NSInteger)row{
    return [self zhTopModelForRow:row].title;
}
- (NSInteger)typeTopForRow:(NSInteger)row{
    return [self zhTopModelForRow:row].type;
}

//判断头部是否有滚动视图
- (BOOL)isExistIndexPic{
    return self.zhTopArr != nil && self.zhTopArr.count != 0;
}


/**
 * 滚动视图以下位置
 */
- (NSInteger)rowNum{
    return self.zhArr.count;
}
- (NSMutableArray *)zhArr{
    if (!_zhArr) {
        _zhArr = [NSMutableArray new];
    }
    return _zhArr;
}
- (ZhiHuStoriesModel *)zhModelForRow:(NSInteger)row{
    return self.zhArr[row];
}


- (NSString *)ga_prefixForRow:(NSInteger)row{
    return [self zhModelForRow:row].ga_prefix;
}
- (NSInteger)story_idForRow:(NSInteger)row{
    return [self zhModelForRow:row].story_id;
}
- (NSURL *)imageForRow:(NSInteger)row{
    return [NSURL URLWithString:[self zhModelForRow:row].images[0]];
}
- (NSString *)titleForRow:(NSInteger)row{
    return [self zhModelForRow:row].title;
}
- (NSInteger)typeForRow:(NSInteger)row{
    return [self zhModelForRow:row].type;
}





/**
 * 公用函数
 */
- (void)getDataCompleteHandle:(void (^)(NSError *error))complete{
    [ZhiHuNetManager getZhiHuCompletionHandle:^(ZhiHuMainModel *model, NSError *error) {
        [self.zhTopArr removeAllObjects];
        [self.zhTopArr addObjectsFromArray:model.top_stories];
        
        [self.zhArr removeAllObjects];
        [self.zhArr addObjectsFromArray:model.stories];
        complete(error);
    }];
}
- (void)refreshDataCompleteHandle:(void (^)(NSError *error))complete{
    [self getDataCompleteHandle:complete];
}

@end
