//
//  WeatherModel.m
//  子曰
//
//  Created by Martell on 15/11/24.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "WeatherModel.h"
@implementation WeatherModel

@end

@implementation WeatherResultModel

@end


@implementation WeatherDataModel

+ (NSDictionary *)objectClassInArray{
    return @{@"weather" : @"WeatherDataWeatherModel"};
}

@end


@implementation WeatherDataLifeModel

@end


@implementation WeatherDataPm25Model

@end


@implementation WeatherDataRealtimeModel

@end


@implementation WeatherDataWeatherModel
+ (NSDictionary *)objectClassInArray{
    return @{@"info" : @"WeatherDataWeatherInfoModel"};
}
@end


@implementation WeatherDataPm25Pm25Model

@end


@implementation WeatherDataRealtimeWindModel

@end


@implementation WeatherDataRealtimeWeatherModel

@end


@implementation WeatherDataWeatherInfoModel

@end
