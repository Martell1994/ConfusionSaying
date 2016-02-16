//
//  NewsPhotoView.m
//  子曰
//
//  Created by Martell on 16/1/26.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "NewsPhotoView.h"

#define margin 10
#define noteTopViewHeight 20
#define noteWidth 18
#define indexLbWidth 15

@implementation NewsPhotoView
- (instancetype)initWithNote:(NSString *)note InView:(UIView *)view{
    if (self = [super init]) {
        self.imgSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50 + 64, kWindowW, kWindowH / 3 + 40)];
        self.imgSV.alwaysBounceHorizontal = YES;
        self.imgSV.userInteractionEnabled = YES;
        self.imgSV.pagingEnabled = YES;
        [view addSubview:self.imgSV];

        self.noteSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kWindowH - 200 - 20, kWindowW, 200)];
        self.noteSV.alwaysBounceVertical = YES;
        self.noteSV.userInteractionEnabled = YES;
        self.noteSV.backgroundColor = [UIColor blackColor];
        [view addSubview:self.noteSV];
        
        UIView *noteTopView = [[UIView alloc]initWithFrame:CGRectMake(margin, kWindowH - 200 - 20, kWindowW - 2 * margin, noteTopViewHeight)];
        noteTopView.backgroundColor = [UIColor blackColor];
        [view addSubview:noteTopView];
        
        self.setnameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, (noteTopViewHeight - indexLbWidth) / 2, kWindowW - 2 * margin - margin * 2 - 40, indexLbWidth)];
        self.setnameLb.textColor = [UIColor whiteColor];
        self.setnameLb.font = [UIFont systemFontOfSize:18 weight:2];
        [noteTopView addSubview:self.setnameLb];
        
        self.indexLb = [[UILabel alloc]initWithFrame:CGRectMake(kWindowW - margin * 2 - 40, (noteTopViewHeight - indexLbWidth) / 2, margin * 2 + 40, indexLbWidth)];
        self.indexLb.textColor = [UIColor whiteColor];
        self.indexLb.font = [UIFont systemFontOfSize:indexLbWidth];
        [noteTopView addSubview:self.indexLb];
        
        //下面label高度会自适应，这里随意写了一个值100
        self.noteLb = [[UILabel alloc]initWithFrame:CGRectMake(margin, noteWidth + margin * 2, kWindowW - margin * 2, 100)];
        self.noteLb.font = [UIFont systemFontOfSize:noteWidth];
        self.noteLb.numberOfLines = 0;
        self.noteLb.textColor = [UIColor whiteColor];
        self.noteLb.text = note;
        self.noteLb.backgroundColor = [UIColor blackColor];
        //自适应高度
        CGRect txtFrame = self.noteLb.frame;
        txtFrame.size.height = [self.noteLb.text boundingRectWithSize:
                                CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.noteLb.font,NSFontAttributeName, nil] context:nil].size.height;
        self.noteLb.frame = CGRectMake(margin, 100, 300, txtFrame.size.height);
        self.noteLb.frame = CGRectMake(margin, noteWidth + margin * 2, kWindowW - margin * 2, txtFrame.size.height);
        //设置notesSV滚动视图contentSize的高度为label的自适应高度
        // + 20是为了弥补contensize的上下间隙
        self.noteSV.contentSize = CGSizeMake(kWindowW, txtFrame.size.height + margin * 2 + noteWidth);
        [self.noteSV addSubview:self.noteLb];
    }
    return self;
}

@end
