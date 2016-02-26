//
//  MyCenterVCViewController.m
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "MyCenterVCViewController.h"
#import "MyCenterTableViewCell.h"
#import "HeaderV.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "EditUserInfoVC.h"

#import "AboutUsViewController.h"
#import "MyMessageViewController.h"
#import "RootViewController.h"
#import "MySavePlaceVC.h"

@interface MyCenterVCViewController ()<UITableViewDataSource,UITableViewDelegate,HeaderActionDelegate,RefreshUserInfoDelegate>
@property (weak, nonatomic) IBOutlet UITableView *setOptionTab;
@property (strong, nonatomic) UserModel *user;

@property (strong, nonatomic) NSArray *settingArr;

@end

@implementation MyCenterVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _setOptionTab.dataSource = self;
    _setOptionTab.delegate = self;
    _settingArr = @[@"我的驴记",@"我的路标",@"我的收藏",@"关于我们",@"退出登录"];
     self.setOptionTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [UserModel reloadUserAndresult:^(BOOL enterEnable) {
        _user = [UserModel sharedUserModel];
        [self loadHeadV];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RootViewController *rootTabBar = (RootViewController *)self.navigationController.tabBarController;
    if (rootTabBar.rootTabBarHidden) {
        [rootTabBar hiddenTabBar:NO andTransFormX:self.view.layer.position.x];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadHeadV{
    
    HeaderV *header = [[HeaderV alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    header.user = _user;
    header.delegate = self;
   
    self.setOptionTab.tableHeaderView = header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _settingArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"settingCell";
    MyCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[MyCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
  
    cell.index = indexPath.row;
    return cell;
}

- (void)didSelectedHeader{
    
    HeaderV *header =(HeaderV *)self.setOptionTab.tableHeaderView ;
    _user.headerImageData = header.headerImageData;
    
    EditUserInfoVC *editUserVC = [[EditUserInfoVC alloc]initWithStyle:UITableViewStyleGrouped];
    editUserVC.user = _user;
    editUserVC.delegate = self;
    
    [self.navigationController presentViewController:editUserVC animated:YES completion:nil];
    
}

- (void)refreshUserInfoAction{
    [UserModel reloadUserAndresult:^(BOOL enterEnable) {
        _user = [UserModel sharedUserModel];
        [self loadHeadV];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"我的驴记");
            MyMessageViewController *myMessage = [[MyMessageViewController alloc]init];
            myMessage.currentUser = _user;
            myMessage.searchIndex = 0;
            myMessage.messageDetailTitle = @"我的驴记";
            [self.navigationController pushViewController:myMessage animated:YES];
        }
            break;
        case 1:
            NSLog(@"我的路标");
        {
            NSLog(@"我的驴记");
            MySavePlaceVC *savePlaceVC = [[MySavePlaceVC alloc]initWithStyle:UITableViewStyleGrouped];
            savePlaceVC.centerSortTitle = @"我的路标";
            [self.navigationController pushViewController:savePlaceVC animated:YES];
        }
            break;
        case 2:
            NSLog(@"我的收藏");
        {
            MyMessageViewController *myMessage = [[MyMessageViewController alloc]init];
            myMessage.currentUser = _user;
            myMessage.searchIndex = 2;
            myMessage.messageDetailTitle = @"我的收藏";
            [self.navigationController pushViewController:myMessage animated:YES];
        }
            break;
        case 3:
            NSLog(@"关于我们");
        {
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc]init];
 
            aboutUsVC.messageDetailTitle = @"关于我们";
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
        case 4:
            [self exitLoding];
            break;
        default:
            break;
    }

    RootViewController *rootTabBar = (RootViewController *)self.navigationController.tabBarController;
    [rootTabBar hiddenTabBar:YES andTransFormX:0.0];
    
}


- (void)exitLoding{
    
    NSUserDefaults *currentUserDf = [NSUserDefaults standardUserDefaults];
    
    [currentUserDf setObject:nil forKey:UserAccount];
    [currentUserDf setObject:nil forKey:UserName];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    LoginViewController *loginVC =( LoginViewController *)[sb instantiateViewControllerWithIdentifier:@"loginVC"];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *mainWindow = [app keyWindow];
    mainWindow.rootViewController = loginVC;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
