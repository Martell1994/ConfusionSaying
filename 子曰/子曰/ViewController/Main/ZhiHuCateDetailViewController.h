//
//  ZhiHuCateDetailViewController.h
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiHuCateDetailViewController : UIViewController
- (instancetype)initWithcateId:(NSInteger)cateId;
@property (nonatomic, assign) NSInteger cateId;
@end
