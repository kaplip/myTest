//
//  MapViewController.m
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "MapViewController.h"
#import "RootViewController.h"
#import "GotoWayTableViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#define ScreenW   [UIScreen mainScreen].bounds.size.width
#define  ScreenH [UIScreen mainScreen].bounds.size.height

#define contast_H  (667.0/ScreenH)
#define contast_W (375.0/ScreenW)

#define toorBar_H 49*contast_H


@interface MapViewController ()<BMKMapViewDelegate,
                                        BMKLocationServiceDelegate,
                                        BMKPoiSearchDelegate,
                                        GotoWayDelegate,
                                        BMKRouteSearchDelegate>


@property (strong, nonatomic) BMKMapView* mapView;
@property (strong, nonatomic) UIToolbar *bottomToolBar;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKPoiSearch *poiSearch;
@property (strong, nonatomic) BMKRouteSearch *routSearch;


@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) CLLocationCoordinate2D clickCoordinate;

@property (strong, nonatomic) NSMutableArray *searchLocationArr;

@property (strong, nonatomic) UIView *asscoryView;

@end

@implementation MapViewController{
    
    UITextField *_inputText;
    UIButton *_leftButton;
    UIButton *_rightButton;
    NSArray *_asscoryButtonImageName;
    NSArray *_asscoryButtonImageSelName;
    NSInteger _selectIndex; //0:步行 ，1：驾车，2：公交，3：地铁
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initNavgationBar];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
   
    if (_mapView==nil) {
        [self initMapView];
    }
    
    if (_bottomToolBar==nil) {
         [self initToolBar];
    }
   
    if (_asscoryView==nil) {
        [self initFindTypeView];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavgationBar{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 38, 25)];
    
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftButton.titleLabel.textColor = [UIColor whiteColor];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [leftButton addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    
}

- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initMapView{
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview: _mapView];
    
    _mapView.overlookEnabled = NO;
    _mapView.rotateEnabled = YES;
  
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    _routSearch = [[BMKRouteSearch alloc]init];
    _locService = [[BMKLocationService alloc]init];
    _poiSearch = [[BMKPoiSearch alloc]init];
    
 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [_mapView viewWillAppear];
     _locService.delegate = self;
    _poiSearch.delegate = self;
    _routSearch.delegate  =self;
    _mapView.delegate = self;
   
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _poiSearch.delegate = nil;
     _routSearch.delegate  =nil;
     _locService.delegate = nil;
    _clickCoordinate = _currentLocation.coordinate;
    
}
#pragma mark 跟新用户面向角度
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    _mapView.rotation = (int)userLocation.heading.trueHeading;
    NSLog(@"heading is %@",userLocation.heading);
}

//更新用户位置信息
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    [_mapView updateLocationData:userLocation];
   _currentLocation = userLocation.location;
    [self didFindUserLocation];
    CLGeocoder *gecoder = [[CLGeocoder alloc]init];

    [gecoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0 && error==nil) {
            CLPlacemark *place = [placemarks lastObject];
            userLocation.title = place.locality;
            userLocation.subtitle = place.subLocality;
            NSString *address = [NSString stringWithFormat:@"%@%@%@",place.administrativeArea,place.locality,place.subLocality];
            [[NSUserDefaults standardUserDefaults] setObject:address forKey:UserLocation];
            [[NSUserDefaults standardUserDefaults]setObject:place.locality forKey:City_Name];
          
            [[NSUserDefaults standardUserDefaults]setFloat:_currentLocation.coordinate.longitude forKey:CurrentCoordinate_log];
            [[NSUserDefaults standardUserDefaults]setFloat:_currentLocation.coordinate.latitude forKey:CurrentCoordinate_lat];
             [[NSUserDefaults standardUserDefaults]setObject:place.administrativeArea forKey:AdministrativeArea];
            [[NSUserDefaults standardUserDefaults]synchronize];
          
        }
    }];
}


- (void)findSelf:(UIButton *)leftButton{
   
    if (leftButton.selected) {
        [_locService stopUserLocationService];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"userlocationButton"] forState:UIControlStateNormal];
        leftButton.selected = NO;
    }else{
        [_locService startUserLocationService];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"userlocationButtonSel"] forState:UIControlStateNormal];
        leftButton.selected = YES;
    }
}

- (void)didFindUserLocation{
    BMKCoordinateSpan span = {0.03,0.03};
    CLLocationCoordinate2D center =_currentLocation.coordinate;
    BMKCoordinateRegion region = {center,span};
    _mapView.centerCoordinate = _currentLocation.coordinate;
    [_mapView setRegion:region animated:YES];
    
}
#pragma mark 初始化路径类型view
- (void)initFindTypeView{
    
   _asscoryView = [[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenW,40/contast_H)];
    [_asscoryView setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:0.5]];
    _asscoryButtonImageName = @[@"man_walk",@"Taxi",@"bus",@"underground"];
    _asscoryButtonImageSelName = @[@"man_walkSel",@"TaxiSel",@"busSel",@"undergroundSel"];
    _selectIndex = 0;
    
    CGFloat margin = (ScreenW-30/contast_W*4)/5;
    for (int i = 0; i<4; i++) {
        
        UIButton *asscoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [asscoryButton setFrame:CGRectMake(margin+(margin+30/contast_W)*i, 5, 30/contast_W, 30/contast_H)];
        [asscoryButton setImage:[UIImage imageNamed:_asscoryButtonImageName[i]] forState:UIControlStateNormal];
        [asscoryButton setImage:[UIImage imageNamed:_asscoryButtonImageSelName[i]] forState:UIControlStateSelected];
        
        asscoryButton.tag = 100+i;
        [asscoryButton addTarget:self action:@selector(choiceFindRoutType:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) {
            asscoryButton.selected = YES;
        }
        
        [_asscoryView addSubview:asscoryButton];
    }
    
    [self.view insertSubview:_asscoryView aboveSubview:_mapView];
}

#pragma mark 初始化位置选项
- (void)initToolBar{
    
    _bottomToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,ScreenH - toorBar_H-self.navigationController.navigationBar.frame.size.height-20 , ScreenW,toorBar_H)];
    [_bottomToolBar setBackgroundImage:[UIImage imageNamed:@"mapSearchBar"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:_bottomToolBar];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setFrame:CGRectMake(0, 0, 35/contast_W, 35/contast_H)];
    [_leftButton setImage:[UIImage imageNamed:@"userlocationButton"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(findSelf:) forControlEvents:UIControlEventTouchUpInside];
    
    _inputText = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 230/contast_W, 35/contast_H)];
    [_inputText setBackground:[UIImage imageNamed:@"inputBackImage"]];
   
    
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55/contast_W, 35/contast_H)];
    [_rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_rightButton setBackgroundColor:[UIColor orangeColor]];
    _rightButton.layer.cornerRadius = 5.0;
    [_rightButton addTarget:self action:@selector(enterSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    UIBarButtonItem *textItem = [[UIBarButtonItem alloc]initWithCustomView:_inputText];
    
    _bottomToolBar.items = @[leftbutton,textItem,rightItem];
}

#pragma mark 键盘呼出和隐藏是toolbar高度自适应
- (void)keyboardWillAppear:(NSNotification *)n{
    NSDictionary *dict = [n userInfo];
    CGSize keyboardSize = [[dict objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size;
    CGFloat durtion = [[dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:durtion animations:^{
        [_bottomToolBar setFrame:CGRectMake(0, ScreenH-keyboardSize.height-toorBar_H-self.navigationController.navigationBar.frame.size.height-20, ScreenW, toorBar_H)];
    }];
    
}

- (void)keyboardWillDisappear:(NSNotification *)n{
    
    NSDictionary *dict = [n userInfo];
    CGFloat durtion = [[dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:durtion animations:^{
        [_bottomToolBar setFrame:CGRectMake(0, ScreenH-toorBar_H-self.navigationController.navigationBar.frame.size.height-20, ScreenW, toorBar_H)];
    }];
}


#pragma mark 选择查询路劲的类型
- (void)choiceFindRoutType:(UIButton *)choiseRouteTypeButton{
    
    _selectIndex = choiseRouteTypeButton.tag - 100;
    for (UIButton *tempB in [_asscoryView subviews]) {
        if (tempB!=choiseRouteTypeButton) {
            tempB.selected = NO;
        }
    }
    choiseRouteTypeButton.selected = YES;
    [self gotoWayByBMKPoiInfo:_clickCoordinate];
}

#pragma mark 执行搜索方法
- (void)enterSearch:(UIButton *)rightButton{
    if(self.searchLocationArr&&self.searchLocationArr.count!=0){
        
        self.searchLocationArr = nil;
    }
    
    [self clearMapView];
    
    //执行搜索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.location = _currentLocation.coordinate;
    option.keyword = _inputText.text;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    BOOL flag= [_poiSearch poiSearchNearBy:option];
    
    if (flag) {
        NSLog(@"周边检索成功");
    }else{
        
        NSLog(@"周边检索失败");
    }
    
    [_inputText endEditing:YES];
    _inputText.text = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    _inputText.text = nil;
    [_inputText endEditing:YES];
}


- (NSMutableArray *)searchLocationArr{
    
    if (_searchLocationArr == nil) {
        _searchLocationArr = [[NSMutableArray alloc]init];
    }
    return _searchLocationArr;
}

#pragma mark 回调检索结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
//      
//        NSLog(@"------totalPoiNum = %i\n",poiResultList.totalPoiNum);
//        NSLog(@"------currPoiNum = %i\n",poiResultList.currPoiNum);
//        NSLog(@"------pageNum = %i\n",poiResultList.pageNum);
//         NSLog(@"------pageIndex = %i\n",poiResultList.pageIndex);
//        NSLog(@"------poiAddressInfoList = %@\n",poiResultList.poiAddressInfoList);
//        NSLog(@"------poiInfoList = %@\n",poiResultList.poiInfoList);
        
        [self.searchLocationArr addObjectsFromArray:poiResultList.poiInfoList];
        for(BMKPoiInfo  *info in  poiResultList.poiInfoList){
            
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = info.pt;
            annotation.title = info.name;
            annotation.subtitle = info.address;
            [_mapView addAnnotation:annotation];
//            
//            NSLog(@"------name = %@",info.name);
//            NSLog(@"------uid  = %@",info.uid);
//            NSLog(@"------address = %@",info.address);
//            NSLog(@"------epoitype = %i",info.epoitype);
        }
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark 跟新大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
        [imageV setImage:[UIImage imageNamed:@"go"]];

        newAnnotationView.rightCalloutAccessoryView = imageV;
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}



#pragma mark 点击大头针响应方法
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
   
    BMKPointAnnotation *annotation = (BMKPointAnnotation *) view.annotation;
    _clickCoordinate= annotation.coordinate;
    
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    
//    GotoWayTableViewController *gotoVC = [[GotoWayTableViewController alloc]init];
//    gotoVC.destinationPoint = self.searchLocationArr;
//    gotoVC.findWaydelegate = self;
//    [self.navigationController pushViewController:gotoVC animated:YES];
    [self gotoWayByBMKPoiInfo:_clickCoordinate];
}


- (void)gotoWayByBMKPoiInfo:(CLLocationCoordinate2D)destinationPoint{
   
    
    [self clearMapView];
    
    _routSearch = [[BMKRouteSearch alloc]init];
    _routSearch.delegate = self;
   
    BMKPlanNode *from = [[BMKPlanNode alloc]init];
    from.pt = _currentLocation.coordinate;
    BMKPlanNode *to = [[BMKPlanNode alloc]init];
    to.pt = destinationPoint;
    
    if (_selectIndex == 0) {
        BMKWalkingRoutePlanOption *walkRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
        walkRouteSearchOption.from = from;
        walkRouteSearchOption.to = to;
        BOOL flag = [_routSearch walkingSearch:walkRouteSearchOption];
         [self cheack:flag andType:@"walk"];

    }
    
    if (_selectIndex == 1) {
        BMKDrivingRoutePlanOption *driveRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        driveRouteSearchOption.from = from;
        driveRouteSearchOption.to = to;
        BOOL flag = [_routSearch drivingSearch:driveRouteSearchOption];
        [self cheack:flag andType:@"drvie"];
        
    }
    if (_selectIndex == 2) {
        BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
        transitRouteSearchOption.from = from;
        transitRouteSearchOption.to = to;
        BOOL flag = [_routSearch transitSearch:transitRouteSearchOption];
        [self cheack:flag andType:@"bus"];
    }
}

- (void)cheack:(BOOL)flag andType:(NSString *)type{
    
    if(flag)
    {
        NSLog(@"%@检索发送成功",type);
    }
    else
    {
        NSLog(@"%@检索发送失败",type);
    }
}


- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    [self clearMapView];

    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
     
        BMKWalkingRouteLine *line = [result.routes lastObject];
        
        NSInteger size = [line.steps count];
        int planPointCounts = 0;
        for (int i = 0; i<size; i++) {
            BMKWalkingStep *walkStep = [line.steps objectAtIndex:i];
            planPointCounts+=walkStep.pointsCount;
        }
        
        int i = 0;
        BMKMapPoint *tempPoints =  new BMKMapPoint[planPointCounts];
        
        for (int j = 0; j<size; j++) {
            BMKWalkingStep *walkstep = [line.steps objectAtIndex:j];
            int k = 0;
            for (k = 0; k<walkstep.pointsCount; k++) {
                tempPoints[i].x = walkstep.points[k].x;
                tempPoints[i].y = walkstep.points[k].y;
                i++;
            }
        }
        
        BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:tempPoints count:planPointCounts];
        
        [_mapView addOverlay:polyLine];
        delete [] tempPoints;
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
    [self clearMapView];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];

            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
 
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }

    
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    
    [self clearMapView];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
//            if(i==0){
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item.coordinate = plan.starting.location;
//                item.title = @"起点";
//                item.type = 0;
//                [_mapView addAnnotation:item]; // 添加起点标注
//                
//            }else if(i==size-1){
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item.coordinate = plan.terminal.location;
//                item.title = @"终点";
//                item.type = 1;
//                [_mapView addAnnotation:item]; // 添加起点标注
//            }
//            RouteAnnotation* item = [[RouteAnnotation alloc]init];
//            item.coordinate = transitStep.entrace.location;
//            item.title = transitStep.instruction;
//            item.type哦   = 3;
//            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
 
}

#pragma mark 绘制路径
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;

}

- (void)clearMapView{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
  
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
