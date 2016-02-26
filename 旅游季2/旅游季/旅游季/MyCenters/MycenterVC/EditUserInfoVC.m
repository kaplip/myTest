//
//  EditUserInfoVC.m
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "EditUserTableViewCell.h"
#import "UserModel.h"
#import "Bmob+BmobDataModelTool.h"
#import "MBProgressHUD+MJ.h"

#define Screen_W  [UIScreen mainScreen].bounds.size.width

@interface EditUserInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *attributeArr;


@end

@implementation EditUserInfoVC{
    
    EditUserTableViewCell *currentCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _attributeArr = @[@"头像:",@"用户名:",@"所在地:",@"驴签"];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]];
    [self saveButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)saveButton{
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(40, 220, Screen_W-80, 30)];
    [button addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0 green:150/255.0 blue:255.0/255.0 alpha:1]];
    
    button.layer.cornerRadius = 10.0;
    button.clipsToBounds = YES;
    
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.attributeArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"userInfoCell";
    EditUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EditUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.user = _user;
    cell.attributeTitle = self.attributeArr[indexPath.row];
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   [ cell.contentView setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    currentCell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row==0) {
        [self imageLibraryFetch];
    }
    
}


- (void)imageLibraryFetch{
    UIImagePickerController *pickVC =[[UIImagePickerController alloc]init];
    pickVC.sourceType = 0;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    UIImage *headerImage = [UIImage imageWithData:data];
    currentCell.headerImage = headerImage;
    _user.headerImageData = data;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"取消");
}

- (void)saveUserInfo{
    for (int i = 0; i<3; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        EditUserTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        switch (i) {
            case 1:
                _user.user_name = cell.textField.text;
                break;
            case 2:
                _user.user_city = cell.textField.text;
                break;
                
            default:
                break;
        }
    }
    
    [Bmob saveHeaderWithUser:_user andResult:^(id result) {
        
        [MBProgressHUD showSuccess:@"用户信息保存成功"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshUserInfoAction)]) {
            [self.delegate refreshUserInfoAction];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
