//
//  MusicDetailCell.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicDetailCell.h"

@implementation MusicDetailCell

- (MImageView *)coverIV {
    if(_coverIV == nil) {
        _coverIV = [[MImageView alloc] init];
        [self.contentView addSubview:_coverIV];
        [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 55));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
        }];
        _coverIV.layer.cornerRadius = 55 / 2;
        //添加播放标识
        UIImageView *playIV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_album_play"]];
        [_coverIV addSubview:playIV];
        [playIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.center.mas_equalTo(0);
        }];
    }
    return _coverIV;
}

- (UILabel *)titleLb {
    if(_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.coverIV.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(self.timeLb.mas_left).mas_equalTo(-10);
        }];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

- (UILabel *)timeLb {
    if(_timeLb == nil) {
        _timeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLb];
        _timeLb.font = [UIFont systemFontOfSize:13];
        _timeLb.textColor = kRGBColor(126, 127, 126);
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(55);
        }];
        _timeLb.textAlignment = NSTextAlignmentRight;
    }
    return _timeLb;
}

- (UILabel *)sourceLb {
    if(_sourceLb == nil) {
        _sourceLb = [[UILabel alloc] init];
        [self.contentView addSubview:_sourceLb];
        [_sourceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.mas_equalTo(self.titleLb.mas_leftMargin);
            make.top.mas_equalTo(self.titleLb.mas_bottom).mas_equalTo(4);
            make.rightMargin.mas_equalTo(self.titleLb.mas_rightMargin);
        }];
        _sourceLb.font=[UIFont systemFontOfSize:15];
        _sourceLb.textColor = kRGBColor(126, 127, 126);
    }
    return _sourceLb;
}

- (UILabel *)playCountLb {
    if(_playCountLb == nil) {
        _playCountLb = [[UILabel alloc] init];
        [self.contentView addSubview:_playCountLb];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_play"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.leftMargin.mas_equalTo(self.sourceLb.mas_leftMargin);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(self.sourceLb.mas_bottom).mas_equalTo(8);
        }];
        [_playCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView);
            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(5);
        }];
        _playCountLb.textColor = kRGBColor(126, 127, 126);
        _playCountLb.font = [UIFont systemFontOfSize:13];
    }
    return _playCountLb;
}


- (UILabel *)durationLb {
    if(_durationLb == nil) {
        _durationLb = [[UILabel alloc] init];
        [self.contentView addSubview:_durationLb];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_duration"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playCountLb.mas_right).mas_equalTo(15);
            make.centerY.mas_equalTo(self.playCountLb);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        [_durationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_equalTo(5);
            make.centerY.mas_equalTo(imageView);
        }];
        _durationLb.textColor = kRGBColor(126, 127, 126);
        _durationLb.font = [UIFont systemFontOfSize:13];
    }
    return _durationLb;
}

- (UIButton *)downloadBtn {
    if(_downloadBtn == nil) {
        _downloadBtn = [UIButton buttonWithType:0];
        [_downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_download"] forState:0];
        [self.contentView addSubview:_downloadBtn];
        [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _downloadBtn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //为了触发下载按钮的懒加载
        self.downloadBtn.hidden = NO;
        //设置cell被选中后的背景色
        UIView *view=[UIView new];
        view.backgroundColor=kRGBColor(243, 255, 254);
        self.selectedBackgroundView=view;
        //分割线距离左侧空间
        self.separatorInset=UIEdgeInsetsMake(0, 76, 0, 0);
    }
    return self;
}


- (DownloadMusicNetManager *)dlmNetManager{
    if(!_dlmNetManager){
        _dlmNetManager = [DownloadMusicNetManager new];
        _dlmNetManager.delegate = self;
    }
    return _dlmNetManager;
}

/** 开始下载某行音频 */
- (void)downLoadMusicURL:(NSURL *)url{
    //    self.downloadBtn.enabled = NO;
    [self.dlmNetManager methodDownloadURL:url];
}

/** 开始下载某行音频图片 */
- (void)downLoadMusicImage:(NSURL *)url{
    //    self.downloadBtn.enabled = NO;
    [self.dlmNetManager methodDownloadURL:url];
}


/** 暂停下载 */
- (void)downloadPause{
    [self.dlmNetManager pauseDownload];
}
/** 继续下载 */
- (void)downloadResume{
    [self.dlmNetManager resumeDownload];
}

- (NSInteger)startOrFinish{
    if(self.dlmNetManager.progress == 0){
        return -1;
    }else if(self.dlmNetManager.progress == 1){
        return 1;
    }else{
        return 0;
    }
}

- (void)tellyouProgress:(CGFloat)progress{
    [self.delegate tellmeProgress:progress withCellTag:self.tag];
}

- (void)tellyouLocation:(NSURL *)location{
    //音乐以MP3格式保存
    NSString *MP3savaFileName = [[[self.titleLb.text stringByAppendingString:@"-"] stringByAppendingString:self.album] stringByAppendingPathExtension:@"mp3"];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *MP3rootPath = [docPath stringByAppendingPathComponent:@"Music"];
    BOOL MP3isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:MP3rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (MP3isSuccess) {
        NSString *filePath = [MP3rootPath stringByAppendingPathComponent:MP3savaFileName];
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
    }
//    //图片以png格式保存
//    NSString *PNGsaveFileName = [self.titleLb.text stringByAppendingPathExtension:@"png"];
//    NSString *PNGrootPath = [docPath stringByAppendingPathComponent:@"Image"];
//    BOOL PNGisSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:PNGrootPath withIntermediateDirectories:YES attributes:nil error:nil];
//    if (PNGisSuccess) {
//        NSString *filePath = [PNGrootPath stringByAppendingPathComponent:PNGsaveFileName];
//        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
//    }
}
@end
