//
//  WeatherViewModel.m
//  子曰
//
//  Created by Martell on 15/11/27.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "WeatherViewModel.h"

@implementation WeatherViewModel
#pragma mark - common code
- (NSMutableArray<WeatherDataWeatherModel *> *)dwArray{
    if(!_dwArray){
        _dwArray = [NSMutableArray new];
    }
    return _dwArray;
}
- (void)getDataCompleteHandle:(void (^)(NSError *))complete{
    [WeatherNetManager getWeatherCity:_cityName completionHandle:^(WeatherModel *model, NSError *error) {
        self.drWeatherModel = model.result.data.realtime.weather;
        self.dlInfoModel = model.result.data.life.info;
        self.dModel = model.result.data;
        self.dpmModel = model.result.data.pm25;
        self.dpmpmModel = model.result.data.pm25.pm25;
        [self.dwArray removeAllObjects];
        [self.dwArray addObjectsFromArray:model.result.data.weather];
        complete(error);
    }];
}
//根据城市名刷新数据
- (void)refreshDataByCity:(NSString *)cityName CompleteHandle:(void (^)(NSError *))complete{
    _cityName = cityName;
    [self getDataCompleteHandle:complete];
}

#pragma mark - other

#pragma mark - WeatherDataRealtimeWeatherModel
- (NSString *)realtimeTemperature{
    return [NSString stringWithFormat:@"%@°C",self.drWeatherModel.temperature];
}

- (NSString *)realtimeHumidity{
    return [NSString stringWithFormat:@"湿度:%@",self.drWeatherModel.humidity];
}

- (NSString *)realtimeInfo{
    return self.drWeatherModel.info;
}

#pragma mark - WeatherDataWeatherInfoModel

- (NSArray *)dayInfo{
    return self.dwInfoModel.day;
}
- (NSArray *)nightInfo{
    return self.dwInfoModel.night;
}

#pragma mark - WeatherDataPM25PM25Model
- (NSString *)weatherQuality{
    return [NSString stringWithFormat:@"空气质量:%@",self.dpmpmModel.quality];
}

@end
