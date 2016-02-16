//
//  ZhiHuCategoryModel.h
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZhiHuOthersModel;
@interface ZhiHuCategoryModel : NSObject

@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSArray<ZhiHuOthersModel *> *others;

@property (nonatomic, strong) NSArray *subscribed;

@end
@interface ZhiHuOthersModel : NSObject

@property (nonatomic, copy) NSString *thumbnail;

@property (nonatomic, assign) NSInteger cate_id;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger color;

@end

