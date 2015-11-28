//
//  MusicCategoryViewModel.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicCategoryViewModel.h"

@implementation MusicCategoryViewModel
- (void)refreshDataCompletionHandle:(CompletionHandle)completionHandle {
    _pageId = 1;
    [self getDataFromNetCompleteHandle:completionHandle];
}

- (void)getMoreDataCompletionHandle:(CompletionHandle)completionHandle {
    if (_maxPageId <= _pageId) {
        NSError *err = [NSError errorWithDomain:@"" code:999 userInfo:@{NSLocalizedDescriptionKey:@"没有更多数据了"}];
        completionHandle(err);
        return;
    }
    _pageId += 1;
    [self getDataFromNetCompleteHandle:completionHandle];
}

- (void)getDataFromNetCompleteHandle:(CompletionHandle)completionHandle {
    self.dataTask = [MusicNetManager getRankListWithPageId:_pageId completionHandle:^(RankListModel *model, NSError *error) {
        if (!error) {
            if (_pageId == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:model.list];
            _maxPageId = model.maxPageId;
            completionHandle(error);
        }
    }];
}

- (RankListListModel *)modelForRow:(NSInteger)row {
    return self.dataArr[row];
}

- (NSInteger)rowNumber {
    return self.dataArr.count;
}

- (NSInteger)albumIdForRow:(NSInteger)row {
    return [self modelForRow:row].albumId;
}

- (NSURL *)iconURLForRow:(NSInteger)row {
    return [NSURL URLWithString:[self modelForRow:row].albumCoverUrl290];
}
- (NSString *)titleForRow:(NSInteger)row {
    return [self modelForRow:row].title;
}

- (NSString *)descForRow:(NSInteger)row {
    return [self modelForRow:row].intro;
}

- (NSString *)numberForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld集",[self modelForRow:row].tracks];
}
@end
