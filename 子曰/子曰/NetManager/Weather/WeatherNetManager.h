//
//  WeatherNetManager.h
//  子曰
//
//  Created by Martell on 15/11/27.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "BaseNetManager.h"
#import "WeatherModel.h"

@interface WeatherNetManager : BaseNetManager
//天气
+ (id)getWeatherCity:(NSString *)cityName completionHandle:(void(^)(WeatherModel *model,NSError *error))completionHandle;
@end
