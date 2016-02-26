//
//  ProfileViewController.m
//  旅游季
//
//  Created by niit on 15/12/26.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "MyMessageViewController.h"
#import "ProfileCollectionViewCell.h"
#import "ShareModel.h"
#import "ProfileViewCellFrame.h"
#import "UserModel.h"
#import <BmobSDK/Bmob.h>

#import "MJRefresh.h"
#import "ZYMFlowLayout.h"
#import "MessageDetailVC.h"
#import "RootViewController.h"
#import "Bmob+BmobDataModelTool.h"

#define NavBar_H self.navigationController.navigationBar.frame.size.height+20

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H   [UIScreen mainScreen].bounds.size.height
@interface MyMessageViewController()<CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic) UICollectionView *collection;

@property (strong, nonatomic) NSMutableArray *cellFrameArr;


@end

@implementation MyMessageViewController{
    
    CLLocationManager *locationManager;
    RefreshType refreshType;
}


- (void)viewDidLoad{
    [super viewDidLoad];
   
    [self initCollection];

    [self setUpRefresh];
   
    [self initNavgationBar];
    [self refreshNewData];
}




static NSString *reuseIdentifier = @"proCollectionCell";
- (void)initCollection{
    
  ZYMFlowLayout  *flowLayout = [[ZYMFlowLayout alloc]init];
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, Screen_W, Screen_H) collectionViewLayout:flowLayout];
    [self.collection registerClass:[ProfileCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [flowLayout computerIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexpath, CGFloat width) {
        ProfileViewCellFrame *cellFrame = self.cellFrameArr[indexpath.row];
        return cellFrame.cellHeight;
    }];
    
    
    _collection.delegate = self;
    _collection.dataSource = self;
    
    [_collection addHeaderWithTarget:self action:@selector(refreshNewData)];
    [_collection addFooterWithTarget:self action:@selector(footerRefresh)];
    self.collection.showsVerticalScrollIndicator = NO;
    self.collection.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.collection];
    [self.collection setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];

}


- (void)setUpRefresh{
    
    self.collection.footerPullToRefreshText = @"加载更多...";
    self.collection.footerReleaseToRefreshText = @"松开我...";
    self.collection.footerRefreshingText = @"努力加载中...";
    self.collection.headerPullToRefreshText = @"加载更多...";
    self.collection.headerReleaseToRefreshText = @"松开我...";
    self.collection.headerRefreshingText = @"努力加载中...";
    
}
#pragma mark initNavgationBar
- (void)initNavgationBar{

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 38, 25)];
   
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [leftButton addTarget:self action:@selector(returnMyCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    titleLabel.text = self.messageDetailTitle;
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)loadMessageInfo:(NSDate *)tempDate{
   
    if (_searchIndex==0) {
        [ShareModel getShareMessageArrWithDate:tempDate andUser:_currentUser.user_b  andResult:^(id resultArray) {
            if (resultArray==nil) {
                [self.collection footerEndRefreshing];
            }else{
                [self endLoadMessageAction:resultArray];
            }
        }];

    }else{
        [ShareModel getMyMessageArrWithDate:tempDate andUser:_currentUser.user_b  andResult:^(id resultArray) {
            if (resultArray==nil) {
                [self.collection footerEndRefreshing];
            }else{
                [self endLoadMessageAction:resultArray];
            }
        }];
        
    }
}


- (void)endLoadMessageAction:(NSMutableArray *)arr{
    NSMutableArray *tempResult = arr;
    if (refreshType==refreshTypeNew) {
        [self refreshNewDate:tempResult];
    }
    if (refreshType == refreshTypeOld) {
        [self refreshOldDate:tempResult];
    }
    [self.collection headerEndRefreshing];
    [self.collection footerEndRefreshing];
}

- (void)refreshNewDate:(NSMutableArray *)newDateArr{
    for (int i = 0;i<newDateArr.count;i++) {
        ShareModel *tempShare = newDateArr[newDateArr.count-1-i];
        ProfileViewCellFrame *cellFrameModel = [[ProfileViewCellFrame alloc]init];
        cellFrameModel.shareModel =tempShare;
            if (![self objectAtFrameArr:cellFrameModel]) {
                [self.cellFrameArr insertObject:cellFrameModel atIndex:0];
                [self.collection reloadData];
            }
    }
}
- (void)refreshOldDate:(NSMutableArray *)oldDateArr{
    
    for (int i = 0;i<oldDateArr.count;i++) {
        ShareModel *tempShare = oldDateArr[i];
        ProfileViewCellFrame *cellFrameModel = [[ProfileViewCellFrame alloc]init];
        cellFrameModel.shareModel =tempShare;
         [cellFrameModel setFrame];
        if (![self objectAtFrameArr:cellFrameModel]) {
            [self.cellFrameArr addObject:cellFrameModel];
            [self.collection reloadData];
        }
    }
}

- (BOOL)objectAtFrameArr:(ProfileViewCellFrame *)tempModel{
    
    BOOL isfount = NO;
    for(ProfileViewCellFrame *frameM in self.cellFrameArr){
        if ([frameM.shareModel.objectKey isEqualToString:tempModel.shareModel.objectKey]) {
            isfount = YES;
        }
    }

    return isfount;
}

- (NSMutableArray *)cellFrameArr{
    
    if (_cellFrameArr == nil) {
        _cellFrameArr = [[NSMutableArray alloc]init];
    }
    return _cellFrameArr;
}

#pragma mark UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.cellFrameArr.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
     ProfileViewCellFrame *cellFrame = self.cellFrameArr[indexPath.row];
    cell.frameModel = cellFrame;
    
    return cell;
}

- (void)refreshNewData{
    refreshType = refreshTypeNew;
    NSDate *date = [NSDate date];

    [self loadMessageInfo:date];
    
}
- (void)footerRefresh{
    refreshType = refreshTypeOld;
    NSString *dateStr;
    ProfileViewCellFrame *tempFrame =self.cellFrameArr.lastObject;
    ShareModel *model = tempFrame.shareModel;
    dateStr = model.createdAt;
    NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
    [dateFor setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFor dateFromString:dateStr];
    
    [self loadMessageInfo:date];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfileCollectionViewCell *cell = (ProfileCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ShareModel *shareModel = cell.frameModel.shareModel;
    MessageDetailVC *messageDetailVC = [[MessageDetailVC alloc]init];
    messageDetailVC.shareModel = shareModel;

    [Bmob modifeChatDate:shareModel.message_b withKey:@"critique_number"];
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

- (void)returnMyCenter{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
