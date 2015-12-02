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
    _task =[session downloadTaskWithURL:url];
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
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY_MM_dd_hh_mm_ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //以MP3格式保存
    NSString *savaFileName = [dateString stringByAppendingPathExtension:@"mp3"];
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [docPath stringByAppendingPathComponent:savaFileName];
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
    NSLog(@"filePath %@", filePath);
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
        NSLog(@"progress:%lf", self.progress);
        if(self.progress >= 1){
            NSLog(@"%f",self.progress);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil userInfo:@{@"progress":@(self.progress)}];
        }
        
    });
}

@end
