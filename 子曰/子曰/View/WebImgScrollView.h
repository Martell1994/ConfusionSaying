//
//  WebImgScrollView.h
//  子曰
//
//  Created by Martell on 16/1/31.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImgScrollView : UIView

/** imgUrl  图像地址*/
@property (nonatomic, copy) NSString *imgUrl;

+ (WebImgScrollView *)showImageWithStr:(NSString *)url;

@end
