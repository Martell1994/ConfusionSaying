//
//  NSObject+Date.h
//  子曰
//
//  Created by Martell on 16/1/24.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Date)
/**
 * 以YYYY-MM-dd HH:mm:ss.SS的形式返回当前时间
 */
-(NSString *)dateForStandardYMdHmsS;
/**
 * 以YYYYMMddHHmmssSS的形式返回当前时间
 */
- (NSString *)dateForYMdHmsS;
/**
 * 将xx:xx转成xxx秒
 */
- (NSTimeInterval)timeByInterval:(NSString *)time;
/**
 * 将xxx秒转成xx:xx
 */
- (NSString *)stringByTime:(NSTimeInterval)time;
@end
