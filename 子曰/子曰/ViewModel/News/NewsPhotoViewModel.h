//
//  NewsPhotoViewModel.h
//  子曰
//
//  Created by Martell on 16/1/24.
//  Copyright © 2016年 Martell. All rights reserved.
//
#import "BaseViewModel.h"
#import "NewsNetManager.h"

@interface NewsPhotoViewModel : BaseViewModel
@property (nonatomic) NSInteger rowNum;
@property (nonatomic,strong) NSMutableArray *newsPhotoArr;
@property (nonatomic,strong) NewsPhotoModel *newsPhotoModel;

- (NSString *)setname;
- (NSURL *)imgurlForRow:(NSInteger)row;
- (NSString *)noteForRow:(NSInteger)row;
- (NSString *)url;
- (NSURL *)cover;
- (void)refreshDataByUrlString:(NSString *)UrlString CompleteHandle:(void (^)(NSError *error))complete;
@end
