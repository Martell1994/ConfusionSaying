//
//  SongTitleScrollView.m
//  子曰
//
//  Created by Martell on 16/1/29.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "SongTitleScrollView.h"
#define margin 5

@implementation SongTitleScrollView{
    NSInteger count;
    NSTimer *t1;
    NSTimer *t2;
}

- (instancetype)initWithLbTxt:(NSString *)txt{
    if (self = [super init]) {
        titleLb = [[UILabel alloc]init];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        self.alwaysBounceHorizontal = YES;
        self.scrollEnabled = NO;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self recal:txt];
    }
    return self;
}
- (void)recal:(NSString *)txt{
    [t1 invalidate];
    [t2 invalidate];
    titleLb.text = txt;
    CGSize size = CGSizeMake(MAXFLOAT, titleLb.frame.size.height);
    NSDictionary *attribute = @{NSFontAttributeName: titleLb.font};
    CGSize lbsize = [titleLb.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    titleLb.textColor = [UIColor whiteColor];
    if (lbsize.width <= kWindowW - 90) {
        [titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWindowW - 90);
        }];
        
    } else {
        titleLb.frame = CGRectMake(0, 0, lbsize.width, lbsize.height);
        [titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(lbsize.width + 1);
        }];
        [self scrollAnimation];
    }
    self.contentSize = CGSizeMake(titleLb.frame.size.width, titleLb.frame.size.height);
}

- (void)scrollAnimation{
    count = -margin;
    [self timer1];
}

- (void)timer1{
    [t2 invalidate];
    if (titleLb.frame.size.width > self.frame.size.width) {
        t1 = [NSTimer bk_scheduledTimerWithTimeInterval:0.05 block:^(NSTimer *timer) {
            count ++;
            [self setContentOffset:CGPointMake(count , 0)];
            if (count > titleLb.frame.size.width - self.frame.size.width + margin) {
                [self timer2];
            }
        } repeats:YES];
    } else {
        
    }
    
}

- (void)timer2{
    [t1 invalidate];
    t2 = [NSTimer bk_scheduledTimerWithTimeInterval:0.05 block:^(NSTimer *timer) {
        count --;
        [self setContentOffset:CGPointMake(count , 0)];
        if (count < -margin) {
            [self timer1];
        }
    } repeats:YES];;
}
@end
