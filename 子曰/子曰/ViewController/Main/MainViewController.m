//
//  MainViewController.m
//  子曰
//
//  Created by Martell on 15/11/3.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherViewModel.h"
#import "ZhiHuCategoryViewModel.h"
#import "ZhiHuCateDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MainViewController ()<CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *PollutionLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *plistPath;
@property (nonatomic,strong) WeatherViewModel *weatherVM;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZhiHuCategoryViewModel *zhCateVM;
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(180);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kWindowH - 230);
        }];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:1],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日精选";
    self.cityLabel.text = [[self PlistDic] objectForKey:@"city"];
    if ([self.cityLabel.text isEqualToString:@"未定位"]) {
        [self startLocationServices];
        self.cityLabel.text = @"定位中";
    }
    [self refreshWeatherInfo:@"杭州市"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.zhCateVM refreshDataCompleteHandle:^(NSError *error) {
            if (error) {
                [self showErrorMsg:error.localizedDescription];
            }else{
                [self.tableView reloadData];
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
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

- (ZhiHuCategoryViewModel *)zhCateVM{
    if (!_zhCateVM) {
        _zhCateVM = [[ZhiHuCategoryViewModel alloc]init];
    }
    return _zhCateVM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.zhCateVM.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZhiHuCateCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZhiHuCateCell"];
    }
    cell.textLabel.text = [self.zhCateVM nameForRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    ZhiHuCateDetailViewController *zhVC = [[ZhiHuCateDetailViewController alloc]initWithcateId:[self.zhCateVM cateIdForRow:indexPath.row]];
    [self.navigationController pushViewController:zhVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
