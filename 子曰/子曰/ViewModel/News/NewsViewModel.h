//
//  NewsViewModel.h
//  子曰
//
//  Created by Martell on 16/1/21.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "NewsNetManager.h"

@interface NewsViewModel : BaseViewModel
/**
 * 滚动视图以上位置
 */
@property (nonatomic) NSInteger rowTopNum;
@property (nonatomic,strong) NSMutableArray *newsTopArr;

@property (nonatomic,strong) NewsAdsModel *newsAdModel;

- (NSString *)docidTopForRow:(NSInteger)row;
- (NSString *)urlTopForRow:(NSInteger)row;
- (NSString *)titleTopForRow:(NSInteger)row;
- (NSString *)subtitleTopForRow:(NSInteger)row;
- (NSString *)tagTopForRow:(NSInteger)row;
- (NSURL *)imgsrcTopForRow:(NSInteger)row;


/**
 * 公用函数
 */
- (void)refreshDataCompleteHandle:(void (^)(NSError *error))complete;
- (void)getMoreDataCompleteHandle:(void (^)(NSError *error))complete;
//判断头部是否有滚动视图
- (BOOL)isExistIndexPic;



/**
 * 滚动视图以下位置
 */
@property (nonatomic) NSInteger rowNum;
@property (nonatomic,strong) NSMutableArray *newsArr;


@property (nonatomic,strong) NewsTModel *newsTModel;
/** 请求新闻数量*/
@property (nonatomic) NSInteger size;

- (NSString *)digestForRow:(NSInteger)row;
- (NSString *)imgsrcForRow:(NSInteger)row;
- (NSString *)ptimeForRow:(NSInteger)row;
- (NSString *)sourceForRow:(NSInteger)row;
- (NSString *)titleForRow:(NSInteger)row;

- (NSInteger)hasHeadForRow:(NSInteger)row;
- (NSString *)photosetIDForRow:(NSInteger)row;
- (NSNumber *)imgTypeForRow:(NSInteger)row;
- (NSArray *)imgextraForRow:(NSInteger)row;

//- (NSURL *)urlForRow:(NSInteger)row;
//- (NSURL *)url3wForRow:(NSInteger)row;
- (NSString *)docidForRow:(NSInteger)row;
- (NSInteger)votecountForRow:(NSInteger)row;
/** 是否有更多页面 */
@property(nonatomic, getter=isHasMore) BOOL hasMore;
@end
