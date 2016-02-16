//
//  AppDelegate.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSString *songDownloadPlistPath;
@end

@implementation AppDelegate

- (NSString *)songDownloadPlistPath {
    if (!_songDownloadPlistPath) {
        _songDownloadPlistPath = [DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"];
    }
    return _songDownloadPlistPath;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.tintColor = dColor;//修改整个应用程序的风格颜色
    [SMSSDK registerApp:smsKey withSecret:smsSecret];
    [Bmob registerWithAppKey:bmobKey];
    NSArray *arr = [NSArray new];
    if (![fileManager fileExistsAtPath:self.songDownloadPlistPath]) {
        [arr writeToFile:self.songDownloadPlistPath atomically:YES];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
