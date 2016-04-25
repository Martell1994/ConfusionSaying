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

@interface SongViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *musicDArr;
@property (nonatomic, strong) NSMutableArray *musicFArr;
@property (nonatomic, strong) NSURL *musicUrl;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchList;
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

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _searchController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar setHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.songType ? @"下载的音乐" : @"喜爱的音乐";
    self.view.backgroundColor = [UIColor whiteColor];
    [Factory addBackItemToVC:self];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downloadTVC_bg"]];
    self.musicDArr = [NSMutableArray new];
    self.musicFArr = [NSMutableArray new];
    self.searchList = [NSMutableArray new];
    if (self.songType == downloadedSongType) {
        NSString *path = [DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"];
        self.musicDArr = [NSMutableArray arrayWithContentsOfFile:path];
    } else {
        BmobQuery *bmobQuery = [BmobQuery new];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *bql = [NSString stringWithFormat:@"select * from ZY_SongFavor where userId = '%@'",delegate.userId];
        [self showProgressOn:self.view];
        [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
            if (result) {
                [self hideProgressOn:self.view];
                for (BmobObject *obj in result.resultsAry) {
                    [self.musicFArr addObject:obj];
                }
                [self.tableView reloadData];
            } else if (error) {
                [self hideProgressOn:self.view];
                [self showErrorMsg:@"出错啦！"];
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.songType == downloadedSongType) {
        if (self.searchController.active) {
            return self.searchList.count;
        } else {
            return self.musicDArr.count;
        }
    } else {
        if (self.searchController.active) {
            return self.searchList.count;
        } else {
            return self.musicFArr.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [[MusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.songType == downloadedSongType) {
        NSDictionary *songDict = [NSDictionary dictionary];
        if (self.searchController.active) {
            songDict = self.searchList[indexPath.row];
        } else {
            songDict = self.musicDArr[indexPath.row];
        }
        cell.songLb.text = songDict[@"song"];
        cell.tickImageView.image = [UIImage imageNamed:@"tick"];
        cell.durationLb.text = songDict[@"duration"];
        cell.singerLb.text = [songDict[@"singer"] stringByAppendingString:@" -"];
        cell.albumLb.text = songDict[@"album"];
    } else {
        BmobObject *songObj = nil;
        if (self.searchController.active) {
            songObj = self.searchList[indexPath.row];
        } else {
            songObj = self.musicFArr[indexPath.row];
        }
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
    NSString *rootPath = [DirectoriesPath stringByAppendingPathComponent:@"Music"];
    NSString *musicString = [[rootPath stringByAppendingPathComponent:cell.songLb.text] stringByAppendingPathExtension:@"mp3"];
    if (self.songType == downloadedSongType) {
        self.musicUrl = [NSURL fileURLWithPath:musicString];
        NSDictionary *dic = [NSDictionary dictionary];
        if (self.searchController.active) {
            dic = self.searchList[indexPath.row];
        } else {
            dic = self.musicDArr[indexPath.row];
        }
        [PlayView sharedInstance].musicDic = dic;
        [PlayView sharedInstance].musicListType = downloadMusicType;
        [PlayView sharedInstance].coverImageURL = [dic objectForKey:@"cover"];
        [[PlayView sharedInstance] playWithURL:self.musicUrl];
        [self presentViewController:vc animated:YES completion:nil];
        [[PlayView sharedInstance] setAlbumCoverImgVRotation];
    } else {//喜爱的音乐
        BmobObject *obj = self.musicFArr[indexPath.row];
        if (self.searchController.active) {
            obj = self.searchList[indexPath.row];
        } else {
            obj = self.musicFArr[indexPath.row];
        }
        NSDictionary *dic = @{@"song":cell.songLb.text,@"duration":cell.durationLb.text,@"singer":[obj objectForKey:@"songSinger"],@"album":cell.albumLb.text,@"url": [obj objectForKey:@"songUrl"]};
        [PlayView sharedInstance].musicDic = dic;
        [PlayView sharedInstance].coverImageURL = [obj objectForKey:@"songCover"];
        [PlayView sharedInstance].musicListType = networkMusicType;
        [PlayView sharedInstance].isNetMusicList = NO;
        if (![fileManager fileExistsAtPath:musicString]) {
            if (ZYDelegate.listenUnderWWAN || ZYDelegate.onLine == 2) {
                [[PlayView sharedInstance] playWithURL:[NSURL URLWithString:[obj objectForKey:@"songUrl"]]];
                [self presentViewController:vc animated:YES completion:nil];
            } else if (ZYDelegate.onLine == 1 && ZYDelegate.listenUnderWWAN == NO) {
                [self showMsg:@"您现在是流量状态，请设置后再听"];
            } else {
                [self showMsg:@"抱歉，您的网络连接已断开"];
            }
        } else {//若已经下载则直接从本地读取Url
            [[PlayView sharedInstance] playWithURL:[NSURL fileURLWithPath:musicString]];
            [self presentViewController:vc animated:YES completion:nil];
        }
        vc.favorType = YES;
        [[PlayView sharedInstance] setAlbumCoverImgVRotation];
    }
}

#pragma mark - 实现UISearchResultsUpdating的required的必须方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    if (self.songType == favorSongType) {
        for (BmobObject *obj in _musicFArr) {
            if ([[obj objectForKey:@"songName"] containsString:[self.searchController.searchBar text]] || [[obj objectForKey:@"songAlbum"] containsString:[self.searchController.searchBar text]] || [[obj objectForKey:@"songSinger"] containsString:[self.searchController.searchBar text]]) {
                [self.searchList addObject:obj];
            }
        }
    } else {
        for (NSDictionary *dic in _musicDArr) {
            if ([[dic objectForKey:@"song"] containsString:[self.searchController.searchBar text]] || [[dic objectForKey:@"singer"] containsString:[self.searchController.searchBar text]] || [[dic objectForKey:@"album"] containsString:[self.searchController.searchBar text]]) {
                [self.searchList addObject:dic];
            }
        }
    }
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark - 删除列表功能
//某行是否支持编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        return NO;
    }
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
        if (self.songType == downloadedSongType) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:self.musicDArr[indexPath.row][@"song"] message:@"删除这首歌?" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:nil];
            UIAlertAction *deleteListAction = [UIAlertAction actionWithTitle:@"仅从列表中删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"仅从列表中删除");
                [self.musicDArr removeObject:self.musicDArr[indexPath.row]];
                if ([self.musicDArr writeToFile:[DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"] atomically:YES]) {
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
            UIAlertAction *deleteDownloadAction = [UIAlertAction actionWithTitle:@"本地音乐同时删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //同时删除图片和音乐资源
                NSString *imageString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Image"], self.musicDArr[indexPath.row][@"song"],@"png");
                NSString *musicString = piece_together([DirectoriesPath stringByAppendingPathComponent:@"Music"], self.musicDArr[indexPath.row][@"song"], @"mp3");
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
                [self.musicDArr removeObject:self.musicDArr[indexPath.row]];
                if ([self.musicDArr writeToFile:[DirectoriesPath stringByAppendingPathComponent:@"songDownload.plist"] atomically:YES]) {
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [alertC addAction:deleteListAction];
            [alertC addAction:deleteDownloadAction];
            [alertC addAction:cancelAction];
        } else {
            BmobObject *deleteObj = self.musicFArr[indexPath.row];
            [deleteObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [self.musicFArr removeObject:deleteObj];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else if (error) {
                    NSLog(@"取消喜爱的歌曲时失败，原因为%@",error);
                } else{
                    NSLog(@"取消喜爱的歌曲时失败，原因未知");
                }
            }];
        }
    }
}

@end
