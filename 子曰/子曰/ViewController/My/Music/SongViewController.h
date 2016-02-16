//
//  SongViewController.h
//  子曰
//
//  Created by Martell on 16/1/22.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>

enum songType {
    favorSongType,
    downloadedSongType
};

@interface SongViewController : UIViewController
@property (nonatomic, assign) enum songType songType;
@end
