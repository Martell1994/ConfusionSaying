//
//  NewsHtmlViewController.h
//  子曰
//
//  Created by Martell on 16/1/22.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsHtmlViewController : UIViewController
- (instancetype)initWithDocId:(NSString *)docId withNewsImage:(NSURL *)newsImage;
@property (nonatomic, strong) NSString *docTitle;
@property (nonatomic, strong) NSString *imgStr;
@end
