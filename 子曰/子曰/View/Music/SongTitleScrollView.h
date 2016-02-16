//
//  SongTitleScrollView.h
//  子曰
//
//  Created by Martell on 16/1/29.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTitleScrollView : UIScrollView{
    UILabel *titleLb;
}
/** 滚动栏效果 */
- (void)scrollAnimation;
/** 初始化滚动视图 */
- (instancetype)initWithLbTxt:(NSString *)txt;
- (void)recal:(NSString *)txt;

/**
 * 用法：
 SongTitleScrollView *sv = [[SongTitleScrollView alloc]initWithLbTxt:@"a b c d e f g h i j k l m n o p q r s t u v w x y z "];
 [self.view addSubview:sv];
 [sv mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.left.mas_equalTo(50);
 make.size.mas_equalTo(CGSizeMake(200, 25));
 }];
 [sv scrollAnimation];
 */
@end
