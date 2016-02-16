//
//  ZhiHuCateDetailModel.h
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZhiHuCateDetailStoriesModel,ZhiHuCateDetailEditorsModel;
@interface ZhiHuCateDetailModel : NSObject

@property (nonatomic, assign) NSInteger color;

@property (nonatomic, copy) NSString *image_source;

@property (nonatomic, strong) NSArray<ZhiHuCateDetailStoriesModel *> *stories;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) NSArray<ZhiHuCateDetailEditorsModel *> *editors;

@property (nonatomic, copy) NSString *background;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *name;

@end
@interface ZhiHuCateDetailStoriesModel : NSObject

@property (nonatomic, assign) NSInteger story_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<NSString *> *images;

@property (nonatomic, assign) NSInteger type;

@end

@interface ZhiHuCateDetailEditorsModel : NSObject

@property (nonatomic, copy) NSString *bio;

@property (nonatomic, assign) NSInteger cateEditorsId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *avatar;

@end

