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
- (NSTimeInterval)timeByInterval:(NSString *)time {
    NSArray *array = [time componentsSeparatedByString:@":"];
    NSString *min = array[0];
    NSString *sec = array[1];
    return [min integerValue] * 60 + [sec integerValue];
}
- (NSString *)stringByTime:(NSTimeInterval)time {
    return [NSString stringWithFormat:@"%02d:%02d",(int)time / 60, (int)time % 60];
}
@end
