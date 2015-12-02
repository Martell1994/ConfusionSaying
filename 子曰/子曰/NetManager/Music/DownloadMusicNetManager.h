//
//  DownloadMusicNetManager.h
//  子曰
//
//  Created by Martell on 15/12/2.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadMusicNetManager : NSObject<NSURLSessionDownloadDelegate>

@property(nonatomic,strong) NSURLSessionDownloadTask *task;
@property(nonatomic,strong) NSData *resumeData;
@property (nonatomic,assign) CGFloat progress;
//下载
- (void)methodDownloadURL:(NSURL *)url;

//取消
- (void)pauseDownload;
//继续
- (void)resumeDownload;
@end
