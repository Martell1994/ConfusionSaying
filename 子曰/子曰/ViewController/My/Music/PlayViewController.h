//
//  PlayViewController.h
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicViewModel.h"

@interface PlayViewController : UIViewController
//@property (nonatomic, assign) NSInteger songId;
//@property (nonatomic, strong) MusicViewModel *musicVM;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, assign) BOOL favorType;
@end
