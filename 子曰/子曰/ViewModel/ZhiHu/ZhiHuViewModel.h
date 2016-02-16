//
//  ZhiHuViewModel.h
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZhiHuNetManager.h"

@interface ZhiHuViewModel : BaseViewModel
/**
 * 滚动视图以上位置
 */
@property (nonatomic) NSInteger rowTopNum;
@property (nonatomic,strong) NSMutableArray *zhTopArr;


- (NSString *)ga_prefixTopForRow:(NSInteger)row;
- (NSInteger)story_idTopForRow:(NSInteger)row;
- (NSURL *)imageTopForRow:(NSInteger)row;
- (NSString *)titleTopForRow:(NSInteger)row;
- (NSInteger)typeTopForRow:(NSInteger)row;


/**
 * 公用函数
 */
- (void)refreshDataCompleteHandle:(void (^)(NSError *error))complete;
//判断头部是否有滚动视图
- (BOOL)isExistIndexPic;


/**
 * 滚动视图以下位置
 */
@property (nonatomic) NSInteger rowNum;
@property (nonatomic,strong) NSMutableArray *zhArr;


- (NSString *)ga_prefixForRow:(NSInteger)row;
- (NSInteger)story_idForRow:(NSInteger)row;
- (NSURL *)imageForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;
- (NSInteger)typeForRow:(NSInteger)row;

@end
