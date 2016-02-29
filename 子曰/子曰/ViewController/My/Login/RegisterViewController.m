//
//  RegisterViewController.m
//  子曰
//
//  Created by Martell on 15/10/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backLogin;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdATF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *name_allow;
@property (weak, nonatomic) IBOutlet UILabel *pwd_allow;
@property (weak, nonatomic) IBOutlet UILabel *pwd_equal;
@property (weak, nonatomic) IBOutlet UILabel *phone_empty;
@property (weak, nonatomic) IBOutlet UILabel *validCode;
@property (nonatomic, assign) NSInteger secondCountDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) BOOL codeCorrect;
@property (nonatomic, assign) BOOL phoneCorrect;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;

@end

@implementation RegisterViewController

kEndEditing

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.secondCountDown = 10;
    self.codeCorrect = NO;
    self.phoneCorrect = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:RegisterViewController_codeCorrect object:nil];
}

- (void)initView {
    _registerBtn.titleLabel.font = LB20;
    _getCodeBtn.titleLabel.font = LB15;
    _backLogin.titleLabel.font = LB20;
    _versionLB.font = LB15;
    _name_allow.font = LB15;
    _pwd_allow.font = LB15;
    _pwd_equal.font = LB15;
    _phone_empty.font = LB15;
    _validCode.font = LB15;
    _registerBtn.layer.cornerRadius = 5;
    _getCodeBtn.layer.cornerRadius = 3;
}

- (IBAction)nameTFNext:(id)sender {
    [_pwdTF becomeFirstResponder];
}

- (IBAction)pwdTFNext:(id)sender {
    [_pwdATF becomeFirstResponder];
}

- (IBAction)pwdATFNext:(id)sender {
    [_phoneTF becomeFirstResponder];
}

- (IBAction)smsCodeTFReturn:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)getSmsCode:(id)sender {
    [_phoneTF resignFirstResponder];
    if (_phoneTF.text.length == 0) {
        _phone_empty.text = @"手机号不能为空";
        _phone_empty.textColor = [UIColor redColor];
    } else {
        [self sendSmsCode];
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
        self.getCodeBtn.enabled = NO;
        self.getCodeBtn.alpha = 0.5;
    }
}

- (void)sendSmsCode {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
        } else {
            NSLog(@"验证码发送成功");
        }
    }];
}

- (void)timeFireMethod:(NSTimer *)timer {
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%ld)",--self.secondCountDown] forState:0];
    if (self.secondCountDown == 0) {
        self.getCodeBtn.enabled = YES;
        self.getCodeBtn.alpha = 1;
        self.secondCountDown = 10;
        [self.getCodeBtn setTitle:@"重新获取验证码" forState:0];
        [self.countDownTimer invalidate];
    }
}

- (void)receive:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    self.codeCorrect = [dic[RegisterViewController_codeCorrect] integerValue];
    if ([self nameAllowOrNot] && [self pwdAllowOrNot] && [self pwdEqualTo] && self.codeCorrect && self.phoneCorrect) {
        [self registerOnBmob];
    } else {
        [self showErrorMsg:@"信息有误,注册失败"];
    }
}


- (BOOL)isTFEmpty:(UITextField *)tf {
    if ([tf.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (IBAction)registerAcc:(id)sender {
    if ([self isTFEmpty:_nameTF] || [self isTFEmpty:_pwdTF] || [self isTFEmpty:_pwdATF] || [self isTFEmpty:_phoneTF] || [self isTFEmpty:_smsCodeTF]) {
        [self showErrorMsg:@"信息不能为空"];
    }
    [_smsCodeTF resignFirstResponder];
}

- (void)registerOnBmob {
    BmobObject *user = [[BmobObject alloc] initWithClassName:@"ZY_User"];
    [user setObject:_nameTF.text forKey:@"userName"];
    [user setObject:_pwdTF.text forKey:@"userPwd"];
    [user setObject:_phoneTF.text forKey:@"userPhone"];
    [user setObject:@"userImg_default" forKey:@"userImg"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self showSuccessMsg:@"恭喜!注册成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showErrorMsg:@"注册失败!请检查网络"];
        }
    }];
}

- (IBAction)backLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)nameAllowOrNot {
    NSString *nameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,20}$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nameRegex];
    if ([nameTest evaluateWithObject:self.nameTF.text]) {
        return YES;
    }
    return NO;
}

- (BOOL)pwdAllowOrNot {
    NSString *pwdRegex = @"^[a-zA-Z0-9]{6,15}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pwdRegex];
    if ([pwdTest evaluateWithObject:self.pwdTF.text]) {
        return YES;
    }
    return NO;
}

- (BOOL)pwdEqualTo {
    if ([self.pwdTF.text isEqualToString:self.pwdATF.text]) {
        return YES;
    }
    return NO;
}

- (IBAction)listenNameTF:(id)sender {
    self.name_allow.text = [self nameAllowOrNot] ? @"用户名输入有效":@"用户名不符合要求,请重新输入";
    self.name_allow.textColor = [self nameAllowOrNot] ? [UIColor lightGrayColor] : [UIColor redColor];
}

- (IBAction)listenPwdTF:(id)sender {
    self.pwd_allow.text = [self pwdAllowOrNot] ? @"密码输入有效":@"密码不符合要求,请重新输入";
    self.pwd_allow.textColor = [self pwdAllowOrNot] ? [UIColor lightGrayColor] : [UIColor redColor];
}

- (IBAction)listenPwdEqualTo:(id)sender {
    if (self.pwdATF.text.length == 0) {
        self.pwd_equal.text = @"重新密码不能为空";
        self.pwd_equal.textColor = [UIColor redColor];
    } else {
        self.pwd_equal.text = [self pwdEqualTo] ? @"再次输入正确":@"两次密码输入不一致";
        self.pwd_equal.textColor = [self pwdEqualTo] ? [UIColor lightGrayColor] : [UIColor redColor];
    }
}

- (IBAction)listenPhoneCorrection:(id)sender {
    if (_phoneTF.text.length) {
        NSString *bql = [NSString stringWithFormat:@"select count(*)from ZY_User where userPhone = '%@'",_phoneTF.text];
        BmobQuery *bmobQuery = [[BmobQuery alloc]init];
        [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
            if (error) {
                NSLog(@"登录失败,服务器出神了");
            } else {
                if (result.count == 0) {
                    _phone_empty.text = @"手机号可用";
                    _phone_empty.textColor = [UIColor lightGrayColor];
                    self.phoneCorrect = YES;
                } else {
                    _phone_empty.text = @"手机号已被注册";
                    _phone_empty.textColor = [UIColor redColor];
                    self.phoneCorrect = NO;
                }
            }
        }];
    }
}

- (IBAction)listenSmsCode:(id)sender {
    NSLog(@"listenSms");
    [self checkCode];
}


- (void)checkSms{
    if (_smsCodeTF.text.length == 0) {
        _validCode.text = @"请输入验证码";
        _validCode.textColor = [UIColor redColor];
    } else {
        [self checkCode];
    }
}

- (void)checkCode {
    [SMSSDK commitVerificationCode:_smsCodeTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
        _validCode.text = error ? @"验证码有误,请重新获取":@"验证码正确";
        _validCode.textColor = error ? [UIColor redColor] : [UIColor lightGrayColor];
        self.codeCorrect = error ? NO : YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:RegisterViewController_codeCorrect object:nil userInfo:@{RegisterViewController_codeCorrect:@(self.codeCorrect)}];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
