//
//  NewsHtmlViewModel.h
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "NewsNetManager.h"

@interface NewsHtmlViewModel : BaseViewModel
@property (nonatomic) NSInteger imgRowNum;
@property (nonatomic,strong) NSMutableArray *newsHtmlImgArr;
@property (nonatomic,strong) NewsHtmlModel *newsHtmlModel;

- (NSString *)title;
- (NSString *)sourceUrl;
- (NSString *)ptime;
- (NSString *)body;

- (NSString *)pixelForRow:(NSInteger)row;
- (NSString *)refForRow:(NSInteger)row;
- (NSString *)srcForRow:(NSInteger)row;

- (void)refreshDataByDocId:(NSString *)docId CompleteHandle:(void (^)(NSError *error))complete;
@end