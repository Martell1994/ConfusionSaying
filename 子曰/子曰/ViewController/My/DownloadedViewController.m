//
//  DownloadedViewController.m
//  子曰
//
//  Created by Martell on 16/1/22.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "DownloadedViewController.h"
#import "PlayViewController.h"
#import "DownloadMusicCell.h"
#import "MusicViewModel.h"
#import "PlayView.h"

@interface DownloadedViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MusicViewModel *musicVM;
@end

@implementation DownloadedViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (MusicViewModel *)musicVM{
    if (!_musicVM) {
        _musicVM=[[MusicViewModel alloc] init];
    }
    return _musicVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下载的音乐";
    self.view.backgroundColor = [UIColor clearColor];
    [Factory addBackItemToVC:self];
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"song.plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadMusicCell *cell = [[DownloadMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"song.plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSDictionary *songDict = arr[indexPath.row];
    cell.songLb.text = songDict[@"song"];
    cell.tickImageView.image = [UIImage imageNamed:@"tick"];
    cell.durationLb.text = songDict[@"duration"];
    cell.singerLb.text = [NSString stringWithFormat:@"%@ ·",songDict[@"singer"]];
    cell.albumLb.text = songDict[@"album"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    DownloadMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *rootPath = [docPath stringByAppendingPathComponent:@"Music"];
    NSString *musicString = [[rootPath stringByAppendingPathComponent:cell.songLb.text] stringByAppendingPathExtension:@"mp3"];
    NSURL *musicUrl = [NSURL fileURLWithPath:musicString];
    PlayViewController *vc = [[PlayViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [[PlayView sharedInstance] playWithURL:musicUrl];
}
@end
