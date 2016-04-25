//
//  FileService.h
//  子曰
//
//  Created by Martell on 16/2/29.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>
//清除SDWebImage的缓存
@interface FileService : NSObject

+ (float)folderSizeAtPath:(NSString *)path;
+ (void)clearCache:(NSString *)path;

@end
