//
//  ZhiHuHtmlModel.h
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhiHuHtmlModel : NSObject
@property (nonatomic, copy) NSString *image_source;

@property (nonatomic, copy) NSString *ga_prefix;

@property (nonatomic, assign) NSInteger story_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) NSArray<NSString *> *css;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, strong) NSArray *js;

@property (nonatomic, copy) NSString *share_url;
@end
