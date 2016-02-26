//
//  ProfileViewController.m
//  旅游季
//
//  Created by niit on 15/12/26.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCollectionViewCell.h"
#import "ShareModel.h"
#import "ProfileViewCellFrame.h"
#import "UserModel.h"
#import <BmobSDK/Bmob.h>
#import <CoreLocation/CoreLocation.h>
#import "MJRefresh.h"
#import "ZYMFlowLayout.h"
#import "MessageDetailVC.h"
#import "RootViewController.h"
#import "Bmob+BmobDataModelTool.h"

#define NavBar_H self.navigationController.navigationBar.frame.size.height+20

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H   [UIScreen mainScreen].bounds.size.height
@interface ProfileViewController()<CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic) UICollectionView *collection;

@property (strong, nonatomic) NSMutableArray *cellFrameArr;


@end

@implementation ProfileViewController{
    
    CLLocationManager *locationManager;
    RefreshType refreshType;
}


- (void)viewDidLoad{
    [super viewDidLoad];
   
    [self initCollection];

    [self setUpRefresh];
   
    [self initNavgationBar];
    [self refreshNewData];
    [self beginLocated];
    
}




static NSString *reuseIdentifier = @"proCollectionCell";
- (void)initCollection{
    
    ZYMFlowLayout *flowLayout = [[ZYMFlowLayout alloc]init];
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
    [leftButton setFrame:CGRectMake(0, 0, 18, 18)];
    [leftButton setImage:[UIImage imageNamed:@"location3"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(beginLocated) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    titleLabel.text = @"首页";
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark 用户定位
- (void)beginLocated{
    
    locationManager = [[CLLocationManager alloc]init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0){
        [locationManager requestWhenInUseAuthorization];
        
    }
    
    locationManager.delegate = self;
    
    locationManager.distanceFilter = 1000;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    CLGeocoder *gecoder = [[CLGeocoder alloc]init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0 && error==nil) {
            CLPlacemark *place = [placemarks lastObject];
            
            [[NSUserDefaults standardUserDefaults]setFloat:location.coordinate.longitude forKey:CurrentCoordinate_log];
            [[NSUserDefaults standardUserDefaults]setFloat:location.coordinate.latitude forKey:CurrentCoordinate_lat];
            
            NSString *address = [NSString stringWithFormat:@"%@%@%@",place.administrativeArea,place.locality,place.subLocality];
            [[NSUserDefaults standardUserDefaults] setObject:address forKey:UserLocation];
            [[NSUserDefaults standardUserDefaults]setObject:place.locality forKey:City_Name];
            [[NSUserDefaults standardUserDefaults]setObject:place.administrativeArea forKey:AdministrativeArea];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
    [locationManager stopUpdatingLocation];
}

- (void)loadMessageInfo:(NSDate *)tempDate{
   
    [ShareModel getShareMessageArrWithDate:tempDate andResult:^(id resultArray) {
        if (resultArray==nil) {
             [self.collection footerEndRefreshing];
        }else{
            NSMutableArray *tempResult = (NSMutableArray *)resultArray;
            if (refreshType==refreshTypeNew) {
                [self refreshNewDate:tempResult];
            }
            if (refreshType == refreshTypeOld) {
                [self refreshOldDate:tempResult];
            }
            [self.collection headerEndRefreshing];
            [self.collection footerEndRefreshing];
        }
    }];
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


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
