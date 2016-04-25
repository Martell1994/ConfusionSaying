//
//  AppDelegate.h
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableButton.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,getter=isOnLine) NSInteger onLine; //网络状态
//记录登录状态,默认未登录为0
@property (nonatomic, assign) BOOL loginOrNot;
//记录用户id
@property (nonatomic, strong) NSString *userId;
//记录流量下是否可以收听音乐
@property (nonatomic, assign) BOOL listenUnderWWAN;
//记录流量下是否可以下载音乐
@property (nonatomic, assign) BOOL downloadUnderWWAN;
//播放方式
@property (nonatomic, assign) NSInteger playType;

@end

