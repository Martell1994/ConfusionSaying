//
//  MusicCategoryViewModel.h
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "MusicNetManager.h"

@interface MusicCategoryViewModel : BaseViewModel

/** 数据的条数 */
@property (nonatomic, assign) NSInteger rowNumber;
/** 某条数据的图片URL */
- (NSURL *)iconURLForRow:(NSInteger)row;
/** 某条数据的题目 */
- (NSString *)titleForRow:(NSInteger)row;
/** 某条数据的秒数 */
- (NSString *)descForRow:(NSInteger)row;
/** 某条数据的集数 */
- (NSString *)numberForRow:(NSInteger)row;
/** 当前页数 */
@property (nonatomic, assign) NSInteger pageId;
/** 当前页数对应的数据ID */
- (NSInteger)albumIdForRow:(NSInteger)row;
/** 当前最大页数 */
@property (nonatomic, assign) NSInteger maxPageId;

@end
