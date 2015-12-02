//
//  PlayView.h
//  子曰
//
//  Created by Martell on 15/12/2.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayView : UIView
+ (PlayView *)sharedInstance;

- (void)playWithURL:(NSURL *)musicURL;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *playBtn;
@end
