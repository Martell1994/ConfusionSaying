//
//  WeatherModel.h
//  子曰
//
//  Created by Martell on 15/11/24.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherResultModel,WeatherDataModel,WeatherDataLifeModel,WeatherDataPm25Model,WeatherDataRealtimeModel,WeatherDataWeatherModel,WeatherDataPm25Pm25Model,WeatherDataLifeInfoModel,WeatherDataRealtimeWindModel,WeatherDataRealtimeWeatherModel,WeatherDataWeatherInfoModel;
@interface WeatherModel : NSObject

@property (nonatomic, strong) WeatherResultModel *result;

@property (nonatomic, assign) NSInteger error_code;

@property (nonatomic, copy) NSString *reason;

@end
@interface WeatherResultModel : NSObject

@property (nonatomic, strong) WeatherDataModel *data;

@end

@interface WeatherDataModel : NSObject

@property (nonatomic, copy) NSString *jingqu;

@property (nonatomic, strong) WeatherDataLifeModel *life;

@property (nonatomic, strong) WeatherDataPm25Model *pm25;

@property (nonatomic, strong) WeatherDataRealtimeModel *realtime;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<WeatherDataWeatherModel *> *weather;

@property (nonatomic, assign) NSInteger isForeign;

@end

@interface WeatherDataPm25Model : NSObject

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) WeatherDataPm25Pm25Model *pm25;

@property (nonatomic, copy) NSString *dateTime;

@property (nonatomic, assign) NSInteger show_desc;

@end

@interface WeatherDataPm25Pm25Model : NSObject

@property (nonatomic, copy) NSString *pm10;

@property (nonatomic, copy) NSString *quality;

@property (nonatomic, copy) NSString *pm25;

@property (nonatomic, copy) NSString *curPm;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *des;

@end

@interface WeatherDataLifeModel : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) WeatherDataLifeInfoModel *info;

@end

@interface WeatherDataLifeInfoModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *ganmao;

@property (nonatomic, strong) NSArray<NSString *> *kongtiao;

@property (nonatomic, strong) NSArray<NSString *> *chuanyi;

@property (nonatomic, strong) NSArray<NSString *> *yundong;

@property (nonatomic, strong) NSArray<NSString *> *ziwaixian;

@property (nonatomic, strong) NSArray<NSString *> *wuran;

@property (nonatomic, strong) NSArray<NSString *> *xiche;

@end

@interface WeatherDataRealtimeModel : NSObject

@property (nonatomic, strong) WeatherDataRealtimeWindModel *wind;

@property (nonatomic, assign) NSInteger dataUptime;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger week;

@property (nonatomic, copy) NSString *city_code;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) WeatherDataRealtimeWeatherModel *weather;

@property (nonatomic, copy) NSString *city_name;

@property (nonatomic, copy) NSString *moon;

@end

@interface WeatherDataRealtimeWindModel : NSObject

@property (nonatomic, copy) NSString *power;

@property (nonatomic, copy) NSString *windspeed;

@property (nonatomic, copy) NSString *direct;

@property (nonatomic, copy) NSString *offset;

@end

@interface WeatherDataRealtimeWeatherModel : NSObject

@property (nonatomic, copy) NSString *temperature;

@property (nonatomic, copy) NSString *humidity;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *img;

@end

@interface WeatherDataWeatherModel : NSObject

@property (nonatomic, copy) NSString *week;

@property (nonatomic, strong) WeatherDataWeatherInfoModel *info;

@property (nonatomic, copy) NSString *nongli;

@property (nonatomic, copy) NSString *date;

@end

@interface WeatherDataWeatherInfoModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *day;

@property (nonatomic, strong) NSArray<NSString *> *night;
@end
