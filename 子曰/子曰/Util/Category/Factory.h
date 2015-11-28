//
//  Factory.h
//  子曰
//
//  Created by Martell on 15/11/12.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Factory : NSObject
/** 向某个控制器上添加返回按钮 */
+ (void)addBackItemToVC:(UIViewController *)vc;
@end
