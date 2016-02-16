//
//  PlayViewController.h
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicViewModel.h"
enum musicListType {
    networkMusicType,
    downloadMusicType
};

@interface PlayViewController : UIViewController
@property (nonatomic, assign) enum musicListType musicListType;
@property (nonatomic, assign) NSInteger songId;
@property (nonatomic, strong) MusicViewModel *musicVM;
@property (nonatomic, strong) NSString *album;
@end
