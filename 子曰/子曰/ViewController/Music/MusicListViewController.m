//
//  MusicListViewController.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicListViewController.h"
#import "PlayViewController.h"
#import "MusicViewModel.h"
#import "AlbumModel.h"
#import "MusicDetailCell.h"
#import "PlayView.h"

@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource,MusicDetailCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MusicViewModel *musicVM;
@property (nonatomic, strong) MusicDetailCell *cell;
@property (nonatomic, strong) NSString *songDownloadPlistPath;
@property (nonatomic, strong) NSMutableArray *cellArr;
@property (nonatomic, strong) NSURL *location;
@property (nonatomic, strong) NSMutableArray *favorArr;
@end

@implementation MusicListViewController
- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [NSMutableArray new];
    }
    return _cellArr;
}

- (MusicViewModel *)musicVM{
    if (!_musicVM) {
        _musicVM=[[MusicViewModel alloc] initWithAlbumId:_albumId];
    }
    return _musicVM;
}

- (NSString *)songDownloadPlistPath {
    if (!_songDownloadPlistPath) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _songDownloadPlistPath = [path stringByAppendingPathComponent:@"songDownload.plist"];
    }
    return _songDownloadPlistPath;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_tableView registerClass:[MusicDetailCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.tableFooterView=[UIView new];
        //给个猜测的行高，让cell可以自行计算应该有的高度
        _tableView.estimatedRowHeight =UITableViewAutomaticDimension;
        _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.musicVM refreshDataCompletionHandle:^(NSError *error) {
                if (error) {
                    [self showErrorMsg:error.localizedDescription];
                }else{
                    [_tableView reloadData];
                    [_tableView.mj_footer resetNoMoreData];
                }
                [_tableView.mj_header endRefreshing];
            }];
        }];
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.musicVM getMoreDataCompletionHandle:^(NSError *error) {
                if (error) {
                    [self showErrorMsg:error.localizedDescription];
                    [_tableView.mj_footer endRefreshing];
                }else{
                    [_tableView reloadData];
                    if (self.musicVM.isHasMore) {
                        [_tableView.mj_footer endRefreshing];
                    }else{
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }];
        }];
    }
    return _tableView;
}

- (instancetype)initWithAlbumId:(NSInteger)albumId{
    if (self = [super init]) {
        self.albumId = albumId;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBottomBarWhenPushed = NO;
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_bg"]];
    self.tableView.backgroundView.alpha = 0.6;
    [Factory addBackItemToVC:self];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    BmobQuery *bmobQuery = [BmobQuery new];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *bql = [NSString stringWithFormat:@"select * from ZY_SongFavor where userId = '%@'",delegate.userId];
    self.favorArr = [NSMutableArray new];
    [bmobQuery queryInBackgroundWithBQL:bql block:^(BQLQueryResult *result, NSError *error) {
        if (result) {
            for (BmobObject *obj in result.resultsAry) {
                [self.favorArr addObject:obj];
            }
        }
    }];
}

- (void)receiveProgress:(NSInteger)index{
    NSLog(@"完成下载啦");
    for (int i = 0; i < self.cellArr.count; i ++) {
        MusicDetailCell *cell = self.cellArr[i];
        if (cell.tag == index) {
            cell.downloadBtn.selected = NO;
            cell.downloadBtn.enabled = NO;
            [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloaded"] forState:UIControlStateDisabled];
            //加入plist
            //下载时间
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:self.songDownloadPlistPath];
            NSString *urlStr = [NSString stringWithFormat:@"%@",[self.musicVM musicURLForRow:index - 100]];
            NSDictionary *dic = @{@"song":cell.titleLb.text,@"duration":cell.durationLb.text,@"singer":cell.sourceLb.text,@"album":self.navigationItem.title,@"time":[self dateForStandardYMdHmsS],@"url": urlStr,@"cover":[self.musicVM largeCoverURLForRow:index - 100]};
            [array addObject:dic];
            [array writeToFile:self.songDownloadPlistPath atomically:YES];
            [self.cellArr removeObject:cell];
        }
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicVM.rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MusicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.delegate = self;
    }
    [cell.coverIV.imageView sd_setImageWithURL:[self.musicVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"cell_bg_noData"]];
    cell.titleLb.text = [self.musicVM titleForRow:indexPath.row];
    cell.timeLb.text = [self.musicVM timeForRow:indexPath.row];
    cell.sourceLb.text = [self.musicVM sourceForRow:indexPath.row];
    cell.playCountLb.text = [self.musicVM playCountForRow:indexPath.row];
    cell.durationLb.text = [self.musicVM durationForRow:indexPath.row];
    cell.album = self.navigationItem.title;
    cell.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithContentsOfFile:self.songDownloadPlistPath];
    for (int i = 0; i < mArr.count; i ++) {
        NSMutableDictionary *mDic = mArr[i];
        //假设歌名不重复
        NSString *title = mDic[@"song"];
        if ([title isEqualToString:[self.musicVM titleForRow:indexPath.row]]) {//已经下载过了
            cell.downloadBtn.enabled = NO;
            [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloaded"] forState:UIControlStateDisabled];
        }
    }
    [cell.downloadBtn bk_addEventHandler:^(id sender) {
        if (ZYDelegate.downloadUnderWWAN || ZYDelegate.onLine == 2) {
            if(cell.startOrFinish == -1){
                cell.downloadBtn.selected = YES;
                NSLog(@"开始下载。。。");
                [cell downLoadMusicURL:[NSURL URLWithString:[self.musicVM musicURLForRow:indexPath.row]]];
                //图片以png格式保存
                NSString *rootPath = [DirectoriesPath stringByAppendingPathComponent:@"Image"];
                BOOL PNGisSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
                if (PNGisSuccess) {
                    NSString *filePath = piece_together(rootPath, cell.titleLb.text, self.navigationItem.title, @"png");
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.musicVM largeCoverURLForRow:indexPath.row]]];
                    [imageData writeToFile:filePath atomically:YES];
                    NSLog(@"下载图片成功");
                }
                [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloading"] forState:UIControlStateSelected];
                self.cell = cell;
                cell.tag = indexPath.row + 100;
                [self.cellArr addObject:cell];
            }else if(cell.startOrFinish == 0){
                if(cell.downloadBtn.selected == YES){
                    cell.downloadBtn.selected = NO;
                    [cell downloadPause];
                    [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"find_album_pause"] forState:UIControlStateNormal];
                }else{
                    cell.downloadBtn.selected = YES;
                    [cell downloadResume];
                    [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloading"] forState:UIControlStateSelected];
                }
            }
        } else if (ZYDelegate.onLine == 0){
            [self showMsg:@"下载失败，请检查网络"];
        } else if (ZYDelegate.onLine == 1 && ZYDelegate.downloadUnderWWAN == NO){
            [self showMsg:@"现在您使用的是流量哦,请设置后再下载"];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayViewController *vc = [[PlayViewController alloc] init];
    [PlayView sharedInstance].musicListType = networkMusicType;
    NSDictionary *dic = @{@"song":[self.musicVM titleForRow:indexPath.row],@"duration":[self.musicVM durationForRow:indexPath.row],@"singer":[self.musicVM sourceForRow:indexPath.row],@"album":self.navigationItem.title,@"time":[self dateForStandardYMdHmsS],@"url": [self.musicVM musicURLForRow:indexPath.row]};
    [PlayView sharedInstance].musicDic = dic;
    [PlayView sharedInstance].coverImageURL = [self.musicVM largeCoverURLForRow:indexPath.row];
    [PlayView sharedInstance].songId = indexPath.row;
    [PlayView sharedInstance].isNetMusicList = YES;
    vc.album = self.navigationItem.title;
    if (ZYDelegate.listenUnderWWAN || ZYDelegate.onLine == 2) {
        [[PlayView sharedInstance] playWithURL:[NSURL URLWithString:[self.musicVM musicURLForRow:indexPath.row]]];
        [self presentViewController:vc animated:YES completion:nil];
    } else if (ZYDelegate.listenUnderWWAN == NO && ZYDelegate.onLine == 1) {
        [self showMsg:@"您现在使用的是流量，请设置后收听"];
        return;
    } else {
        [self showMsg:@"请检查网络"];
        return;
    }
    
    [[PlayView sharedInstance] setAlbumCoverImgVRotation];
    NSInteger i = 0;
    [[PlayView sharedInstance].playingList removeAllObjects];
    for (AlbumTracksListModel *ATL in self.musicVM.dataArr) {
        NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%ld",i],@"song":ATL.title,@"duration":[NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)ATL.duration / 60, (NSInteger)ATL.duration % 60],@"singer":ATL.nickname,@"album":self.navigationItem.title,@"cover":ATL.coverLarge,@"url": ATL.playUrl64};
        [[PlayView sharedInstance].playingList addObject:dic];
        i++;
    }
}

//允许自动布局
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - MusicDetailCellDelegate
- (void)tellmeProgress:(CGFloat)progress withCellTag:(NSInteger)tag{
    if (progress >= 1) {
        [self receiveProgress:tag];
    }
}


@end
