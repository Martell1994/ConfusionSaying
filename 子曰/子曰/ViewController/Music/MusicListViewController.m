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
#import "MusicDetailCell.h"
#import "PlayView.h"
#import "SmallPlayView.h"

@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource,MusicDetailCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MusicViewModel *musicVM;
@property (nonatomic, strong) MusicDetailCell *cell;
@property (nonatomic, strong) NSString *songPlistPath;
@property (nonatomic, strong) NSMutableArray *cellArr;
@property (nonatomic, strong) NSURL *location;
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

- (NSString *)songPlistPath {
    if (!_songPlistPath) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _songPlistPath = [path stringByAppendingPathComponent:@"song.plist"];
        NSLog(@"初次创建song plist");
    }
    return _songPlistPath;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_bg"]];
    self.tableView.backgroundView.alpha = 0.6;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveProgress:) name:MusicListViewController_download object:nil];
    [Factory addBackItemToVC:self];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:[SmallPlayView sharedInstance]];
    [[SmallPlayView sharedInstance] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-80);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(30);
    }];
    [[SmallPlayView sharedInstance].playViewBtn bk_addEventHandler:^(id sender) {
        PlayViewController *vc = [PlayViewController new];
        [self presentViewController:vc animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)receiveProgress:(NSInteger)index{
//    NSDictionary *dic = notification.userInfo;
//    NSString *progressStr = dic[@"progress"];
//    NSLog(@"notice:%f",progressStr.floatValue);
    NSLog(@"完成下载啦");
    
    for (int i = 0; i < self.cellArr.count; i ++) {
        MusicDetailCell *cell = self.cellArr[i];
        if (cell.tag == index) {
            cell.downloadBtn.selected = NO;
            cell.downloadBtn.enabled = NO;
            [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloaded"] forState:UIControlStateDisabled];
            //加入plist
            //图像
            //NSData *imgData = UIImagePNGRepresentation(self.cell.imageView.image);
            //下载时间
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:self.songPlistPath];
            NSDictionary *dic = @{@"song":cell.titleLb.text,@"duration":cell.durationLb.text,@"singer":cell.sourceLb.text,@"album":self.navigationItem.title,@"time":[self dateForStandardYMdHmsS]};
            [array addObject:dic];
            [array writeToFile:self.songPlistPath atomically:YES];
            
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
    [cell.coverIV.imageView sd_setImageWithURL:[self.musicVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"cell_bg_noData_1"]];
    cell.titleLb.text = [self.musicVM titleForRow:indexPath.row];
    cell.timeLb.text = [self.musicVM timeForRow:indexPath.row];
    cell.sourceLb.text = [self.musicVM sourceForRow:indexPath.row];
    cell.playCountLb.text = [self.musicVM playCountForRow:indexPath.row];
    cell.durationLb.text = [self.musicVM durationForRow:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithContentsOfFile:self.songPlistPath];
    for (int i = 0; i < mArr.count; i ++) {
        NSMutableDictionary *mDic = mArr[i];
        //假设歌名不重复
        NSString *title = mDic[@"song"];
        if ([title isEqualToString:[self.musicVM titleForRow:indexPath.row]]) {//已经下载过了
//            cell.downloadBtn.selected = YES;
            cell.downloadBtn.enabled = NO;
            [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloaded"] forState:UIControlStateDisabled];
            
        }
    }
    
    [cell.downloadBtn bk_addEventHandler:^(id sender) {
        if(cell.startOrFinish == -1){
            cell.downloadBtn.selected = YES;
            NSLog(@"开始下载。。。");
            NSLog(@"下载按钮%ld被点击...",indexPath.row);
            [cell downLoadMusicURL:[self.musicVM musicURLForRow:indexPath.row]];
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
    } forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[self.musicVM musicURLForRow:indexPath.row]);
    PlayViewController *vc = [[PlayViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [[PlayView sharedInstance] playWithURL:[self.musicVM musicURLForRow:indexPath.row]];
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
