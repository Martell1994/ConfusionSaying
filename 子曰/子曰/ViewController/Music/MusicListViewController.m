//
//  MusicListViewController.m
//  子曰
//
//  Created by Martell on 15/11/28.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicViewModel.h"
#import "MusicDetailCell.h"
#import "PlayView.h"

@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MusicViewModel *musicVM;
@property (nonatomic, strong) MusicDetailCell *cell;
@end

@implementation MusicListViewController
- (MusicViewModel *)musicVM{
    if (!_musicVM) {
        _musicVM=[[MusicViewModel alloc] initWithAlbumId:_albumId];
    }
    return _musicVM;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveProgress:) name:@"test" object:nil];
    
    
    // Do any additional setup after loading the view.
    [Factory addBackItemToVC:self];
    [self.tableView.mj_header beginRefreshing];
    //添加播放控制视图
    [self.view addSubview:[PlayView sharedInstance]];
    [[PlayView sharedInstance] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}


- (void)receiveProgress:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    NSString *progressStr = dic[@"progress"];
    NSLog(@"notice:%f",progressStr.floatValue);
    NSLog(@"完成下载啦");
    [self.cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloaded"] forState:UIControlStateSelected|UIControlStateNormal];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MusicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell.coverIV.imageView sd_setImageWithURL:[self.musicVM coverURLForRow:indexPath.row] placeholderImage:[UIImage imageNamed:@"cell_bg_noData_1"]];
    cell.titleLb.text=[self.musicVM titleForRow:indexPath.row];
    cell.timeLb.text = [self.musicVM timeForRow:indexPath.row];
    cell.sourceLb.text=[self.musicVM sourceForRow:indexPath.row];
    cell.playCountLb.text=[self.musicVM playCountForRow:indexPath.row];
    cell.favorCountLb.text=[self.musicVM favorCountForRow:indexPath.row];
    cell.commentCountLb.text=[self.musicVM commentCountForRow:indexPath.row];
    cell.durationLb.text = [self.musicVM durationForRow:indexPath.row];
    
    [cell.downloadBtn bk_addEventHandler:^(id sender) {
        if(cell.startOrFinish == -1){
            cell.downloadBtn.selected = YES;
            NSLog(@"开始下载。。。");
            NSLog(@"下载按钮%ld被点击...",indexPath.row);
            [cell downLoadMusicURL:[self.musicVM musicURLForRow:indexPath.row]];
            [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"cell_downloading"] forState:UIControlStateSelected];
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
        self.cell = cell;
    } forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[self.musicVM musicURLForRow:indexPath.row]);
    [[PlayView sharedInstance] playWithURL:[self.musicVM musicURLForRow:indexPath.row]];
}
//允许自动布局
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

@end
