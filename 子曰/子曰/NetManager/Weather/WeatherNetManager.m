//
//  WeatherNetManager.m
//  子曰
//
//  Created by Martell on 15/11/27.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "WeatherNetManager.h"
//key
static NSString *const key = @"d2361c1db64dabb39158d6b9bdc3efae";
@implementation WeatherNetManager
+ (id)getWeatherCity:(NSString *)cityName completionHandle:(void (^)(WeatherModel *, NSError *))completionHandle{
    cityName = [cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *path = [NSString stringWithFormat:@"http://op.juhe.cn/onebox/weather/query?cityname=%@&key=%@",cityName,key];
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandle([WeatherModel mj_objectWithKeyValues:responseObj],error);
    }];
}
@end
