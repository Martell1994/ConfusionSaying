//
//  LoginViewController.m
//  子曰
//
//  Created by Martell on 15/10/27.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"


@interface LoginViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic, strong) NSString *userPlistPath;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation LoginViewController

initHUDView
errorHUD

- (NSString *)userPlistPath {
    if (!_userPlistPath) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _userPlistPath = [path stringByAppendingPathComponent:@"user.plist"];
    }
    return _userPlistPath;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

//初始化界面设置
- (void)initView {
    _loginBtn.titleLabel.font = LB20;
    _registerBtn.titleLabel.font = LB20;
    _versionLB.font = LB15;
    _loginBtn.layer.cornerRadius = 5;
    _registerBtn.layer.cornerRadius = 5;
}

//初始化登录信息
- (void)initData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.userPlistPath]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.userPlistPath];
        _nameTF.text = [dic objectForKey:@"phone"];
        _pwdTF.text = [dic objectForKey:@"pwd"];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)nameTFNext:(id)sender {
    [self.pwdTF becomeFirstResponder];
}

- (IBAction)login:(id)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.dimBackground = YES;
    HUD.labelText = @"正在登录";
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD showWhileExecuting:@selector(loginMethod) onTarget:self withObject:nil animated:YES];
}

- (void)loginMethod {
    NSString *bql = [NSString stringWithFormat:@"select *from ZY_User where userPhone = '%@' and userPwd = '%@'", _nameTF.text, _pwdTF.text];
    BmobQuery *bmobQuery = [[BmobQuery alloc]init];
    [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        if (error) {
            [self showErrorHUD:@"登录失败!请检查网络"];
        } else {
            if (result.resultsAry.count == 0) {
                [self showErrorHUD:@"登录失败!用户名或密码有误"];
            } else {
                [self saveToPlist:result];
                [self jumpToTabBarController];
            }
        }
    }];
}
//跳转界面
- (void)jumpToTabBarController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
    [self presentViewController:tabbar animated:YES completion:nil];
}

//将登录信息保存到数据库
- (void)saveToPlist:(BQLQueryResult *)result {
    BmobObject *obj = (BmobObject *)result.resultsAry[0];
    //用户ID
    NSString *userId = [obj objectId];
    //创建日期
    NSDate *createdData = [obj createdAt];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用户名
    NSString *userName = [obj objectForKey:@"userName"];
    //用户性别
    NSString *gender = [obj objectForKey:@"userGender"];
    //头像
    NSString *headImage = [obj objectForKey:@"userImg"];
    gender = (gender == nil) ? @"未设置" : gender;
    NSDictionary *dic = @{@"id":userId, @"name":userName, @"phone":_nameTF.text, @"pwd":_pwdTF.text, @"createdTime":[dateFormatter stringFromDate:createdData], @"headerImage":headImage, @"gender":gender, @"city":@"未定位"};
    [dic writeToFile:self.userPlistPath atomically:YES];
}

@end
