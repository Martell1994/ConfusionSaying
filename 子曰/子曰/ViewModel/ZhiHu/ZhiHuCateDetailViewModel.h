//
//  ZhiHuCateDetailViewModel.h
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZhiHuNetManager.h"

@interface ZhiHuCateDetailViewModel : BaseViewModel

@property (nonatomic) NSInteger rowNum;
@property (nonatomic,strong) NSMutableArray *zhCDArr;
- (NSInteger)storyIdForRow:(NSInteger)row;
- (NSURL *)imageForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;
- (NSInteger)typeForRow:(NSInteger)row;


@property (nonatomic,strong) ZhiHuCateDetailModel *zhCDModel;
/** 资讯分类名字*/
- (NSString *)name;
/** 图片url */
- (NSURL *)imageUrl;

- (void)refreshDataByCateId:(NSInteger)cateId CompleteHandle:(void (^)(NSError *error))complete;
@end
