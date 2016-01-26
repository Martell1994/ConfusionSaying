//
//  MyReferenceViewController.m
//  子曰
//
//  Created by Martell on 15/11/6.
//  Copyright © 2015年 Martell. All rights reserved.
//

#import "MyReferenceViewController.h"
#import <BmobSDK/BmobProFile.h>
#import "EditAccCell.h"

@interface MyReferenceViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) NSString *plistPath;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *cameraImageView;
@property (nonatomic, strong) UIButton *editHeadImageBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSString *bmobFileURL;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation MyReferenceViewController

plistPath_lazy
kEndEditing
getPlistDic
initHUDNav
errorHUD
successHUD

- (UIImageView *)headImageView {
    if(_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

- (UIImageView *)cameraImageView {
    if (!_cameraImageView) {
        _cameraImageView = [[UIImageView alloc] init];
        _cameraImageView.image = [UIImage imageNamed:@"camera"];
        _cameraImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cameraImageView;
}

- (UIButton *)editHeadImageBtn {
    if(_editHeadImageBtn == nil) {
        _editHeadImageBtn = [UIButton buttonWithType:0];
    }
    return _editHeadImageBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[EditAccCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView registerClass:[EditAccChoice class] forCellReuseIdentifier:@"Choice"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Factory addBackItemToVC:self];
    //[[UITextField appearance] setFont:[UIFont fontWithName:@"melon" size:15]];
    self.title = @"修改信息";
    self.view.backgroundColor = kRGBColor(240, 240, 240);
    [self addHeadImageView];
    [self addCameraImageView];
    [self addEditHeadImageBtn];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.editHeadImageBtn.mas_bottom).mas_equalTo(20);
        make.height.mas_equalTo(149);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(showWithLabel)];
    self.navigationItem.rightBarButtonItem.tintColor = kRGBColor(110, 153, 106);
}

- (void)saveToBmobAndPlist {
    NSLog(@"%@",_plistPath);
    NSData *imageData = UIImageJPEGRepresentation(_headImageView.image, 0);
    _headImageView.image = [UIImage imageWithData:imageData];
    [BmobProFile uploadFileWithFilename:@"headerImage.jpg" fileData:imageData block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        if (isSuccessful) {
            self.bmobFileURL = file.url;
            self.filename = filename;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MyReferenceViewController_save object:nil userInfo:nil];
    } progress:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCell) name:MyReferenceViewController_save object:nil];
}

- (void)saveCell {
    EditAccCell *nameCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    EditAccCell *pwdCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    EditAccChoice *sexCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    //保存至Plist
    NSMutableDictionary *info = [[[NSMutableDictionary alloc] initWithContentsOfFile:_plistPath] mutableCopy];
    [info setValue:nameCell.textField.text forKey:@"name"];
    [info setValue:pwdCell.textField.text forKey:@"pwd"];
    [info setValue:sexCell.editLabel.text forKey:@"gender"];
    [info setValue:self.bmobFileURL forKey:@"headerImage"];
    //[info setValue:self.imageData forKey:@"headerImage"];
    [info writeToFile:self.plistPath atomically:YES];
    //保存至Bmob
    BmobObject *user = [BmobObject objectWithoutDatatWithClassName:ZY_User objectId:[[self PlistDic] valueForKey:@"id"]];
    [user setObject:nameCell.textField.text forKey:@"userName"];
    [user setObject:pwdCell.textField.text forKey:@"userPwd"];
    [user setObject:sexCell.editLabel.text forKey:@"userGender"];
    [user setObject:self.bmobFileURL forKey:@"userImg"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self completeHub:@"保存成功"];
        } else {
            [self completeHub:@"保存失败,请检查网络"];
        }
    }];
}

- (void)showWithLabel {
    EditAccCell *nameCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    EditAccCell *pwdCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([nameCell.textField.text isEqualToString:@""] || [pwdCell.textField.text isEqualToString:@""]) {
        [self showErrorHUD:@"昵称与密码不能为空"];
    } else{
        self.HUD.labelText = @"正在保存";
        _HUD.customView = nil;
        _HUD.mode = MBProgressHUDModeIndeterminate;
        [_HUD show:YES];
        [self saveToBmobAndPlist];
    }
}

- (void)addHeadImageView {
    [self.view addSubview:self.headImageView];
    NSString *imageName = [[self PlistDic] objectForKey:@"headerImage"];
    if ([imageName isEqualToString:@"userImg_default"]) {
        _headImageView.image = [UIImage imageNamed:@"userImg_default"];
    } else {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(NaviHeight + 20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)addCameraImageView {
    [self.view addSubview:self.cameraImageView];
    [_cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 30));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(NaviHeight + 105);
    }];
}

- (void)addPwdLabel {
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.text = @"密码";
    pwdLabel.textColor = [UIColor grayColor];
    pwdLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:pwdLabel];
    [pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(_editHeadImageBtn.mas_bottom).mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
}

- (void)addEditHeadImageBtn {
    [self.view addSubview:self.editHeadImageBtn];
    [_editHeadImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NaviHeight + 20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 115));
    }];
    [_editHeadImageBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click {
    UIImagePickerController *pc = [UIImagePickerController new];
    pc.delegate = self;
    pc.allowsEditing = YES;
    [self presentViewController:pc animated:YES completion:nil];
}


#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //UIImage *image = info[UIImagePickerControllerOriginalImage];
    //获取编辑后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    _headImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        EditAccCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.tipLabel.text = @"昵称";
        cell.textField.text = [[self PlistDic] valueForKey:@"name"];
        [cell.textField setTag:0];
        return cell;
    } else if (indexPath.row == 1){
        EditAccCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.tipLabel.text = @"密码";
        cell.textField.text = [[self PlistDic] valueForKey:@"pwd"];
        cell.textField.secureTextEntry = YES;
        return cell;
    } else {
        EditAccChoice *cell = [tableView dequeueReusableCellWithIdentifier:@"Choice"];
        cell.editLabel.text = [[self PlistDic] valueForKey:@"gender"];
        cell.tipLabel.text = @"性别";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EditAccChoice *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.editLabel.text = action.title;
        }];
        UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EditAccChoice *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.editLabel.text = action.title;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:maleAction];
        [alertC addAction:femaleAction];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
