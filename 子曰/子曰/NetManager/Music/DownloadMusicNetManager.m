//
//  DownloadMusicNetManager.m
//  子曰
//
//  Created by Martell on 15/12/2.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "DownloadMusicNetManager.h"

@implementation DownloadMusicNetManager
//开始
- (void)methodDownloadURL:(NSURL *)url{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    _task = [session downloadTaskWithURL:url];
    [_task resume];
}
//暂停
- (void)pauseDownload{
    [_task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}
//继续
- (void)resumeDownload{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    _task=[session downloadTaskWithResumeData:self.resumeData];
    [_task resume];
}


#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{

    //以MP3格式保存
    [self.delegate tellyouLocation:location];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
//        NSLog(@"progress:%lf", self.progress);
//        if(self.progress >= 1){
//            NSLog(@"%f",self.progress);
            [self.delegate tellyouProgress:self.progress];
//            [[NSNotificationCenter defaultCenter] postNotificationName:MusicListViewController_download object:nil userInfo:@{@"progress":@(self.progress)}];
//        }
    });
}

@end
