//
//  LoginViewController.m
//  子曰
//
//  Created by Martell on 15/10/27.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "LoginViewController.h"
#import "PlayView.h"


@interface LoginViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (nonatomic, copy) NSString *userPlistPath;
@property (nonatomic, copy) NSString *userId;
@end

@implementation LoginViewController

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
    _logoutBtn.titleLabel.font = LB20;
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
    [self showProgressOn:self.view];
    NSString *bql = [NSString stringWithFormat:@"select *from ZY_User where userPhone = '%@' and userPwd = '%@'", _nameTF.text, _pwdTF.text];
    BmobQuery *bmobQuery = [[BmobQuery alloc]init];
    [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        [self hideProgressOn:self.view];
        if (error) {
            [self showErrorMsg:@"登录失败!请检查网络"];
        } else {
            if (result.resultsAry.count == 0) {
                [self showErrorMsg:@"登录失败!用户名或密码有误"];
            } else {
                [self saveToPlist:result];
                [self jumpToTabBarController];
            }
        }
    }];
}

- (IBAction)logout:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//跳转界面
- (void)jumpToTabBarController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
    [self presentViewController:tabbar animated:YES completion:nil];
    
    //[self showViewController:[UIApplication sharedApplication].keyWindow.rootViewController sender:nil];
    ZYDelegate.loginOrNot = 1;
    ZYDelegate.userId =self.userId;
}

//将登录信息保存到本地数据库
- (void)saveToPlist:(BQLQueryResult *)result {
    BmobObject *obj = (BmobObject *)result.resultsAry[0];
    self.userId = [obj objectId];
    NSDate *createdData = [obj createdAt];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *userName = [obj objectForKey:@"userName"];
    NSString *gender = [obj objectForKey:@"userGender"];
    NSString *headImage = [obj objectForKey:@"userImg"];
    gender = (gender == nil) ? @"未设置" : gender;
    NSDictionary *dic = @{@"id":self.userId, @"name":userName, @"phone":_nameTF.text, @"pwd":_pwdTF.text, @"createdTime":[dateFormatter stringFromDate:createdData], @"headerImage":headImage, @"gender":gender};
    [dic writeToFile:self.userPlistPath atomically:YES];
}

@end
