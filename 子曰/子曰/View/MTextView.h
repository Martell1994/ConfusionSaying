//
//  MTextView.h
//  子曰
//
//  Created by Martell on 16/2/15.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTextView : UITextView

@property(nonatomic,copy) NSString *myPlaceholder;  //文字
@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色

@end
