//
//  ZhiHuHtmlViewController.h
//  子曰
//
//  Created by Martell on 16/1/30.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

enum intoType {
    ZYIntoType,
    WXSIntoType
};

@interface ZhiHuHtmlViewController : UIViewController
- (instancetype)initWithStoryId:(NSInteger)storyId;
@property(nonatomic) NSInteger storyId;
@property (nonatomic, strong) NSString *storyTitle;
@property (nonatomic, strong) NSString *storySource;
//0代表从子曰进入 1代表从吾先生进入
@property (nonatomic, assign) enum intoType intoType;
@end
