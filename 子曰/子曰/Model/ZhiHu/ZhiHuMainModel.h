//
//  ZhiHuMainModel.h
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZhiHuStoriesModel,ZhiHuTop_StoriesModel;
@interface ZhiHuMainModel : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<ZhiHuStoriesModel *> *stories;

@property (nonatomic, strong) NSArray<ZhiHuTop_StoriesModel *> *top_stories;

@end
@interface ZhiHuStoriesModel : NSObject

@property (nonatomic, assign) NSInteger story_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSArray<NSString *> *images;

@property (nonatomic, copy) NSString *ga_prefix;

@end

@interface ZhiHuTop_StoriesModel : NSObject

@property (nonatomic, assign) NSInteger story_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *ga_prefix;

@end

