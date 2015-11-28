//
//  MusicCategoryCell.h
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MImageView.h"

@interface MusicCategoryCell : UITableViewCell

/** 序号标签 */
@property (nonatomic, strong) UILabel *orderLb;
/** 类型图片 */
@property (nonatomic, strong) MImageView *iconIV;
/** 类型名称 */
@property (nonatomic, strong) UILabel *titleLb;
/** 类型描述 */
@property (nonatomic, strong) UILabel *descLb;
/** 集数 */
@property (nonatomic, strong) UILabel *numberLb;
/** 集数图标 */
@property (nonatomic, strong) MImageView *numberIV;

@end
