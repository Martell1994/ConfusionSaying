//
//  NewsViewModel.m
//  子曰
//
//  Created by Martell on 16/1/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsViewModel.h"
//最大新闻数
#define maxSize 400

@implementation NewsViewModel
/**
 * 滚动视图以上位置
 */
- (NSInteger)rowTopNum{
    return self.newsTopArr.count;
}
- (NSMutableArray *)newsTopArr{
    if (!_newsTopArr) {
        _newsTopArr = [NSMutableArray new];
    }
    return _newsTopArr;
}
- (NewsAdsModel *)newsAdsModelForRow:(NSInteger)row{
    if (self.newsTopArr.count - 1 >= row) {
        return self.newsTopArr[row];
    }else{
        NSLog(@"图片数组出错啦～");
        return nil;
    }
}

- (NSString *)docidTopForRow:(NSInteger)row{
    return [self newsAdsModelForRow:row].docid;
}

- (NSString *)urlTopForRow:(NSInteger)row{
    return [self newsAdsModelForRow:row].url;
}
- (NSString *)titleTopForRow:(NSInteger)row{
    return [self newsAdsModelForRow:row].title;
}
- (NSString *)subtitleTopForRow:(NSInteger)row{
    return [self newsAdsModelForRow:row].subtitle;
}
- (NSString *)tagTopForRow:(NSInteger)row{
    return [self newsAdsModelForRow:row].tag;
}
- (NSURL *)imgsrcTopForRow:(NSInteger)row{
    return [NSURL URLWithString:[self newsAdsModelForRow:row].imgsrc];
}




/**
 * 滚动视图以下位置
 */
- (NSInteger)rowNum{
    return self.newsArr.count;
}
- (NSMutableArray *)newsArr{
    if (!_newsArr) {
        _newsArr = [NSMutableArray new];
    }
    return _newsArr;
}
- (NewsTModel *)newsTModelForRow:(NSInteger)row{
    return self.newsArr[row];
}

//判断头部是否有滚动视图
- (BOOL)isExistIndexPic{
    return self.newsTopArr != nil && self.newsTopArr.count != 0;
}

- (NSString *)digestForRow:(NSInteger)row{
    return [self newsTModelForRow:row].digest;
}
- (NSString *)imgsrcForRow:(NSInteger)row{
    return [self newsTModelForRow:row].imgsrc;
}
- (NSString *)ptimeForRow:(NSInteger)row{
    return [self newsTModelForRow:row].ptime;
}
- (NSString *)sourceForRow:(NSInteger)row{
    return [self newsTModelForRow:row].source;
}

- (NSString *)titleForRow:(NSInteger)row{
    return [self newsTModelForRow:row].title;
}

- (NSInteger)hasHeadForRow:(NSInteger)row{
    return [self newsTModelForRow:row].hasHead;
}
- (NSString *)photosetIDForRow:(NSInteger)row{
    return [self newsTModelForRow:row].photosetID;
}
- (NSNumber *)imgTypeForRow:(NSInteger)row{
    return [self newsTModelForRow:row].imgType;
}
- (NSArray *)imgextraForRow:(NSInteger)row{
    return [self newsTModelForRow:row].imgextra;
}
- (NSString *)docidForRow:(NSInteger)row{
    return [self newsTModelForRow:row].docid;
}
- (NSInteger)votecountForRow:(NSInteger)row{
    return [self newsTModelForRow:row].votecount;
}
- (BOOL)isHasMore{
    return maxSize > _size;
}



/**
 * 公用函数
 */
- (void)getDataCompleteHandle:(void (^)(NSError *error))complete{
    [NewsNetManager getNewsBySize:_size CompletionHandle:^(NewsModel *model, NSError *error) {
        if (model.T1348647853363.count != 0) {
            
            if (_size == 0) {
                [self.newsArr removeAllObjects];
            }
            NSMutableArray *tempArr = [NSMutableArray new];
            [tempArr addObjectsFromArray:model.T1348647853363];
            [tempArr removeObjectAtIndex:0];
            for (NewsTModel *tModel in [tempArr copy]) {
                if (![[tModel.docid substringToIndex:1] isEqualToString:@"B"]) {
                    [tempArr removeObject:tModel];
                }
            }
            [self.newsArr addObjectsFromArray:tempArr];
            [self.newsTopArr removeAllObjects];
            NewsTModel *nTModel = model.T1348647853363[0];
            [self.newsTopArr addObjectsFromArray:nTModel.ads];
            //过滤掉顶部滚动视图中的专题新闻
            for (NewsAdsModel *nAdsModel in nTModel.ads) {
                if ([nAdsModel.tag isEqualToString:@"special"]) {
                    [self.newsTopArr removeObject:nAdsModel];
                }
            }
        }
        complete(error);
    }];
}
- (void)refreshDataCompleteHandle:(void (^)(NSError *error))complete{
    _size = 0;
    [self getDataCompleteHandle:complete];
}
- (void)getMoreDataCompleteHandle:(void (^)(NSError *error))complete{
    if(self.isHasMore){
        _size += 10;
        [self getDataCompleteHandle:complete];
    }else{
        NSError *err = [NSError errorWithDomain:@"" code:999 userInfo:@{NSLocalizedDescriptionKey:@"没有更多数据"}];
        complete(err);
    }
    
}
// 








@end
