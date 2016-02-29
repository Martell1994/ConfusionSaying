//
//  Contants.h
//  子曰
//
//  Created by Martell on 15/11/6.
//  Copyright © 2015年 Martell. All rights reserved.
//

#ifndef Contants_h
#define Contants_h

/** 通知名集合，方便查看 */
//  验证码通知的通知名
#define RegisterViewController_codeCorrect @"RegisterViewController_codeCorrect"
#define MyReferenceViewController_save @"MyReferenceViewController_save"
#define MainViewController_city @"MainViewController_city"
#define MusicListViewController_download @"MusicListViewController_download"

//plistPath的懒加载方法
#define plistPath_lazy - (NSString *)plistPath { \
                        if (!_plistPath) { \
                                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject; \
                                _plistPath = [path stringByAppendingPathComponent:@"user.plist"];} \
                        return _plistPath;}

#define getPlistDic - (NSDictionary *)PlistDic { \
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.plistPath]) { \
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.plistPath]; \
                return dic;} \
        return nil;}
//导航栏
#define NaviHeight   self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height

//通过RGB设置颜色
#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
//设置tintColor #6E996A
#define dColor kRGBColor(110, 153, 106)

#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度

//放弃第一响应者
#define kEndEditing   - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { \
[self.view endEditing:YES];}

//数据库用户表名
#define ZY_User @"ZY_User"

//字体
#define LB20 [UIFont fontWithName:@"STLibian-SC-Regular" size:20]
#define LB15 [UIFont fontWithName:@"STLibian-SC-Regular" size:15]

#define piece_together(path,txt1,txt2,extension) [[[[path stringByAppendingPathComponent:txt1] stringByAppendingString:@"-"] stringByAppendingString:txt2] stringByAppendingPathExtension:extension]

//文件管理器对象
#define fileManager [NSFileManager defaultManager]

//文件路径
#define DirectoriesPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

//delegate对象
#define ZYDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#endif /* Contants_h */
