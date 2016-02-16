//
//  ZhiHuCategoryViewModel.h
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZhiHuNetManager.h"

@interface ZhiHuCategoryViewModel : BaseViewModel

@property (nonatomic) NSInteger rowNum;
@property (nonatomic,strong) NSMutableArray *zhCateArr;


- (NSInteger)colorForRow:(NSInteger)row;
- (NSString *)descForRow:(NSInteger)row;
- (NSInteger)cateIdForRow:(NSInteger)row;
- (NSString *)nameForRow:(NSInteger)row;
- (NSURL *)thumbnailForRow:(NSInteger)row;

- (void)refreshDataCompleteHandle:(void (^)(NSError *error))complete;
@end
