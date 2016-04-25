//
//  ZhiHuHtmlViewModel.m
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "ZhiHuHtmlViewModel.h"

@implementation ZhiHuHtmlViewModel
- (NSString *)body{
    return self.zhHtmlModel.body;
}
- (NSArray *)css{
    return self.zhHtmlModel.css;
}
- (NSString *)ga_prefix{
    return self.zhHtmlModel.ga_prefix;
}
- (NSInteger)storyId{
    return self.zhHtmlModel.story_id;
}
- (NSURL *)image{
    return [NSURL URLWithString:self.zhHtmlModel.image];
}
- (NSString *)imageSource{
    return self.zhHtmlModel.image_source;
}
- (NSArray *)js{
    return self.zhHtmlModel.js;
}
- (NSString *)shareUrl{
    return self.zhHtmlModel.share_url;
}
- (NSString *)title{
    return self.zhHtmlModel.title;
}
- (NSInteger)type{
    return self.zhHtmlModel.type;
}

- (void)getDataByStoryId:(NSInteger)storyId CompleteHandle:(void (^)(NSError *error))complete{
    [ZhiHuNetManager getZhiHuHtmlByStoryId:storyId CompletionHandle:^(ZhiHuHtmlModel *model, NSError *error) {
        self.zhHtmlModel = model;
        complete(error);
    }];
    
}
- (void)refreshDataByStoryId:(NSInteger)storyId CompleteHandle:(void (^)(NSError *error))complete{
    [self getDataByStoryId:storyId CompleteHandle:complete];
}
@end
