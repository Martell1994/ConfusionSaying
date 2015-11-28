//
//  EditAccCell.h
//  子曰
//
//  Created by Martell on 15/11/7.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAccCell : UITableViewCell
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextField *textField;
@end

@interface EditAccChoice : UITableViewCell
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *editLabel;
@end
