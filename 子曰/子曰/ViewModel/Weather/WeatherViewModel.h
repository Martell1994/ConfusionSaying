//
//  WeatherViewModel.h
//  子曰
//
//  Created by Martell on 15/11/27.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "BaseViewModel.h"
#import "WeatherNetManager.h"

@interface WeatherViewModel : BaseViewModel
@property (nonatomic,strong) WeatherDataRealtimeWeatherModel *drWeatherModel;
@property (nonatomic,strong) WeatherDataLifeInfoModel *dlInfoModel;
@property (nonatomic,strong) WeatherDataModel *dModel;
@property (nonatomic,strong) WeatherDataWeatherInfoModel *dwInfoModel;
@property (nonatomic,strong) WeatherDataPm25Model *dpmModel;
@property (nonatomic,strong) WeatherDataPm25Pm25Model *dpmpmModel;
@property (nonatomic,strong) NSMutableArray <WeatherDataWeatherModel *> *dwArray;
@property (nonatomic,strong) NSString *cityName;

//WeatherDataRealtimeWeatherModel
- (NSString *)realtimeTemperature;

- (NSString *)realtimeHumidity;

- (NSString *)realtimeInfo;

//common
- (void)refreshDataByCity:(NSString *)cityName CompleteHandle:(void (^)(NSError *error))complete;

//WeatherDataPM25PM25Model
- (NSString *)weatherQuality;
@end
