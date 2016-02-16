//
//  ZhiHuHtmlViewModel.h
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZhiHuNetManager.h"

@interface ZhiHuHtmlViewModel : BaseViewModel

@property (nonatomic,strong) ZhiHuHtmlModel *zhHtmlModel;

- (NSString *)body;
- (NSArray *)css;
- (NSString *)ga_prefix;
- (NSInteger)storyId;
- (NSURL *)image;
- (NSString *)imageSource;
- (NSArray *)js;
- (NSURL *)shareUrl;
- (NSString *)title;
- (NSInteger)type;

- (void)refreshDataByStoryId:(NSInteger)storyId CompleteHandle:(void (^)(NSError *error))complete;
@end
