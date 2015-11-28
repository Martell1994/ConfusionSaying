//
//  MainViewController.m
//  子曰
//
//  Created by Martell on 15/11/3.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherViewModel.h"
#import <CoreLocation/CoreLocation.h>

@interface MainViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *PollutionLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *plistPath;
@property (nonatomic,strong) WeatherViewModel *weatherVM;
@end

@implementation MainViewController

plistPath_lazy
getPlistDic

- (WeatherViewModel *)weatherVM{
    if (!_weatherVM) {
        _weatherVM = [WeatherViewModel new];
    }
    return _weatherVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日精选";
    self.cityLabel.text = [[self PlistDic] objectForKey:@"city"];
    if ([self.cityLabel.text isEqualToString:@"未定位"]) {
        [self startLocationServices];
        self.cityLabel.text = @"定位中";
    }
    [self refreshWeatherInfo:@"杭州市"];//
    
}

//开启定位服务
- (void)startLocationServices {
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    //NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",currentLocation.coordinate.latitude, currentLocation.coordinate.longitude]);
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSMutableDictionary *info = [[[NSMutableDictionary alloc] initWithContentsOfFile:_plistPath] mutableCopy];
        NSString *city = placemarks.firstObject.locality;
        if (city) {
            self.cityLabel.text = city;
            [info setValue:self.cityLabel.text forKey:@"city"];
            [info writeToFile:self.plistPath atomically:YES];
            [self refreshWeatherInfo:city];
        }
    }];
}
- (IBAction)setLocation:(UIButton *)sender {
    [self startLocationServices];
    self.cityLabel.text = @"定位中";
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
    self.cityLabel.text = @"定位失败";
}

//刷新首页上方天气状况
- (void)refreshWeatherInfo:(NSString *)city{
    [self.weatherVM refreshDataByCity:city CompleteHandle:^(NSError *error) {
        self.tempLabel.text = [self.weatherVM realtimeTemperature];
        self.weatherLabel.text = [self.weatherVM realtimeInfo];
        self.PollutionLabel.text = [self.weatherVM weatherQuality];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}
@end
