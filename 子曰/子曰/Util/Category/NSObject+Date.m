//
//  NSObject+Date.m
//  子曰
//
//  Created by Martell on 16/1/24.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NSObject+Date.h"

@implementation NSObject (Date)
- (NSString *)dateForStandardYMdHmsS{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SS"];
    NSString *timeFormatter = [dateFormatter stringFromDate:currentTime];
    return timeFormatter;
}

- (NSString *)dateForYMdHmsS{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmssSS"];
    NSString *timeFormatter = [dateFormatter stringFromDate:currentTime];
    return timeFormatter;
}

- (NSString *)dateForYYMMddWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *timeFormatter = [dateFormatter stringFromDate:date];
    timeFormatter = [timeFormatter substringFromIndex:2];
    return timeFormatter;
}
@end
