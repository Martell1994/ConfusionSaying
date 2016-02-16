//
//  SongViewController.m
//  子曰
//
//  Created by Martell on 16/1/22.
//  Copyright © 2016年 Martell. All rights reserved.
//

#import "SongViewController.h"
#import "PlayViewController.h"
#import "MusicCell.h"
#import "MusicViewModel.h"
#import "PlayView.h"

@interface SongViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *musicArr;
@property (nonatomic, strong) NSURL *musicUrl;
@end

@implementation SongViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.songType ? @"下载的音乐" : @"喜爱的音乐";
    self.view.backgroundColor = [UIColor clearColor];
    [Factory addBackItemToVC:self];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downloadTVC_bg"]];
    self.musicArr = [NSMutableArray new];
    if (self.songType == favorSongType) {
        BmobQuery *bmobQuery = [BmobQuery new];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *bql = [NSString stringWithFormat:@"select * from ZY_SongFavor where userId = '%@'",delegate.userId];
        [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
            if (result) {
                for (BmobObject *obj in result.resultsAry) {
                    [self.musicArr addObject:obj];
                }
                [self.tableView reloadData];
            }
        }];
    } else {
        NSString *path = [DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"];
        self.musicArr = [NSMutableArray arrayWithContentsOfFile:path];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [[MusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.songType == downloadedSongType) {
        NSDictionary *songDict = self.musicArr[indexPath.row];
        cell.songLb.text = songDict[@"song"];
        cell.tickImageView.image = [UIImage imageNamed:@"tick"];
        cell.durationLb.text = songDict[@"duration"];
        cell.singerLb.text = [songDict[@"singer"] stringByAppendingString:@" -"];
        cell.albumLb.text = songDict[@"album"];
    } else {
        BmobObject *songObj = self.musicArr[indexPath.row];
        cell.songLb.text = [songObj objectForKey:@"songName"];
        cell.tickImageView.image = [UIImage imageNamed:@"love"];
        cell.durationLb.text = [songObj objectForKey:@"songDuration"];
        cell.singerLb.text = [[songObj objectForKey:@"songSinger"] stringByAppendingString:@" -"];
        cell.albumLb.text = [songObj objectForKey:@"songAlbum"];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PlayViewController *vc = [[PlayViewController alloc] init];
    if (self.songType == downloadedSongType) {
        NSString *rootPath = [DirectoriesPath stringByAppendingPathComponent:@"Music"];
        NSString *musicString = [[[[rootPath stringByAppendingPathComponent:cell.songLb.text] stringByAppendingString:@"-"] stringByAppendingString:cell.albumLb.text] stringByAppendingPathExtension:@"mp3"];
        self.musicUrl = [NSURL fileURLWithPath:musicString];
        [PlayView sharedInstance].musicDic = self.musicArr[indexPath.row];
        vc.musicListType = downloadMusicType;
    } else {
        NSDictionary *dic = @{@"song":cell.songLb.text,@"duration":cell.durationLb.text,@"singer":cell.singerLb.text,@"album":cell.albumLb.text,@"url": [self.musicArr[indexPath.row] objectForKey:@"songUrl"]};
        [PlayView sharedInstance].musicDic = dic;
        [PlayView sharedInstance].coverImageURL = [self.musicArr[indexPath.row] objectForKey:@"songCover"];
        [self presentViewController:vc animated:YES completion:nil];
        [[PlayView sharedInstance] playWithURL:[NSURL URLWithString:[self.musicArr[indexPath.row] objectForKey:@"songUrl"]]];
        vc.musicListType = networkMusicType;
    }
    
    [self presentViewController:vc animated:YES completion:nil];
    [[PlayView sharedInstance] playWithURL:self.musicUrl];
}


//某行是否支持编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//某行的编辑状态是哪一种
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//删除状态的文字是什么
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:self.musicArr[indexPath.row][@"song"] message:@"删除这首歌?" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction *deleteListAction = [UIAlertAction actionWithTitle:@"仅从列表中删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"仅从列表中删除");
            [self.musicArr removeObject:self.musicArr[indexPath.row]];
            if ([self.musicArr writeToFile:[DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"] atomically:YES]) {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        UIAlertAction *deleteDownloadAction = [UIAlertAction actionWithTitle:@"本地音乐同时删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //同时删除图片和音乐资源
            NSString *imageString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Image"], self.musicArr[indexPath.row][@"song"], self.musicArr[indexPath.row][@"album"], @"png");
            NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], self.musicArr[indexPath.row][@"song"], self.musicArr[indexPath.row][@"album"], @"mp3");
            BOOL imageDelete = NO;
            BOOL musicDelete = NO;
            if ([fileManager fileExistsAtPath:imageString]) {
                imageDelete = [fileManager removeItemAtPath:imageString error:nil];
            }
            if ([fileManager fileExistsAtPath:musicString]) {
                musicDelete = [fileManager removeItemAtPath:musicString error:nil];
            }
            if (!(imageDelete && musicDelete)) {
                NSLog(@"本地文件删除失败");
            }
            [self.musicArr removeObject:self.musicArr[indexPath.row]];
            if ([self.musicArr writeToFile:[DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"] atomically:YES]) {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertC addAction:deleteListAction];
        [alertC addAction:deleteDownloadAction];
        [alertC addAction:cancelAction];
    }
}

@end
