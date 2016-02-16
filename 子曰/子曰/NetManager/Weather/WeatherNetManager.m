//
//  WeatherNetManager.m
//  子曰
//
//  Created by Martell on 15/11/27.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "WeatherNetManager.h"
//key
static NSString *const key = @"858904ce87e84142633f6e29d6a5181b";
@implementation WeatherNetManager
+ (id)getWeatherCity:(NSString *)cityName completionHandle:(void (^)(WeatherModel *, NSError *))completionHandle{
    cityName = [cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *path = [NSString stringWithFormat:@"http://op.juhe.cn/onebox/weather/query?cityname=%@&key=%@",cityName,key];
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([WeatherModel mj_objectWithKeyValues:responseObj],error);
    }];
}
@end
