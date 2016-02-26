//
//  NearSearchTableViewController.m
//  旅游季
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 niit. All rights reserved.
//




#import "NearSearchTableViewController.h"
#import "NearDetailTableViewCell.h"
#import "NearHeaderView.h"
#import "NearSectionView.h"

#import "CityModel.h"
#import "ItinerarieModel.h"
#import "ItDetailFrameModel.h"
#import "ItinerarieDetailModel.h"
#import "PathDetailModel.h"

#import "PathDetailViewController.h"

NSString *ReloadNearTabDataNot;

#define navBar_H 69
#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height
@interface NearSearchTableViewController ()<UITableViewDataSource,UITableViewDelegate,NearSectionClickDelegate>



@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UINavigationBar *rootNavigationBar;

@property (strong,nonatomic)CityModel *cityModel;
@property (strong, nonatomic) NSArray *itinerModels;
@property (strong, nonatomic) NSString *currentCityName;

@property (strong, nonatomic) UITextField *placeText;
@property (strong, nonatomic) UITextField *accessoryTextFeild;
@property (strong, nonatomic) UIView *accessoryView;
@end

@implementation NearSearchTableViewController{
    UIButton *leftButton;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentCityName = @"北京";
    [self initTableView];
    [self initHeader];
    [self loadData];
    [self initNavgationItem];
    [self initNavgationBar];
    [self initAccessoreView];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, 0, 0, 0)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)initNavgationItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *locationStr =@"切换";
    [button setTitle:locationStr forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 43, 43)];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(changePalce:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)initTableView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}


- (void)initHeader{
    
    NearHeaderView *headerV = [[NearHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 0)];
    self.tableView.tableHeaderView = headerV;
    self.tableView.tableHeaderView.layer.shadowOpacity = 0.3;
    self.tableView.tableHeaderView.layer.shadowOffset = CGSizeMake(5,5);
    self.tableView.tableHeaderView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
 
}


- (void)initAccessoreView{
    self.placeText = [[UITextField alloc]init];
    [self.view addSubview:self.placeText];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 45)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    _accessoryTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, Screen_W-80, 35)];
    _accessoryTextFeild.placeholder = @"请输入地点";
    _accessoryTextFeild.borderStyle = UITextBorderStyleRoundedRect;
    
    CGFloat _accessoryTextFeild_X = CGRectGetMaxX(_accessoryTextFeild.frame);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendCriAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(_accessoryTextFeild_X+5, 5, 65, 35)];
    
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    
    [view addSubview:_accessoryTextFeild];
    [view addSubview:button];
    
    self.placeText.inputAccessoryView = view;
}

- (void)loadData{
    NSLog(@"currentCity  = %@",_currentCityName);
    [CityModel fetchDataWithCityName:_currentCityName complete:^(id result) {
        CityModel *cityModel = (CityModel *)result;
        NearHeaderView *header = (NearHeaderView *)self.tableView.tableHeaderView;
        header.cityModel  = cityModel;
        [header setFrame:CGRectMake(0, 0, Screen_W, header.headerHeight)];
        [self.tableView setTableHeaderView:header];
   
        _cityModel = cityModel;
        _itinerModels = cityModel.itinerariModels;
    
        [self.tableView reloadData];
    }];
}

- (void)sendCriAction{
    
    NSString *str = [_accessoryTextFeild.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_accessoryTextFeild.text!=nil&&str.length!=0) {
        _currentCityName = _accessoryTextFeild.text;
        [self loadData];
    }
    [self.accessoryTextFeild resignFirstResponder];
    self.accessoryTextFeild.text = nil;
}

- (void)keyboardShow{
    [self.accessoryTextFeild becomeFirstResponder];
}

//切换地点
- (void)changePalce:(UIButton *)tempButton{
    [self.placeText becomeFirstResponder];
}

- (void)returnAction:(UIButton *)tempButton{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryaWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itinerModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.itinerModels.count!=0) {
        ItinerarieModel *itModel = self.itinerModels[section];
        return itModel.itinerarieDetails.count;
    }else{
        return 0;
    }
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     static NSString *identifier = @"nearSearchCell";
 NearDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     if (cell==nil) {
         cell = [[NearDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
   
     ItinerarieModel *itMdoel = self.itinerModels[indexPath.section];
     ItinerarieDetailModel *detailModel = itMdoel.itinerarieDetails[indexPath.row];
     ItDetailFrameModel *itFramedoel = [[ItDetailFrameModel alloc]init];
     itFramedoel.itDetailModel = detailModel;
     
     cell.index = (int)[indexPath row]+1;
     cell.itDetailFrameModel = itFramedoel;
 // Configure the cell...
 
 return cell;
 }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItinerarieModel *itMdoel = self.itinerModels[indexPath.section];
    ItinerarieDetailModel *detailModel = itMdoel.itinerarieDetails[indexPath.row];
    ItDetailFrameModel *itFramedoel = [[ItDetailFrameModel alloc]init];
    itFramedoel.itDetailModel = detailModel;
    return itFramedoel.cellHeight+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NearSectionView *sectionHeader = [[NearSectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 0)];
    sectionHeader.itinerarieModel =_itinerModels[section];
    
    return sectionHeader.sectionHeaderH;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NearSectionView *sectionHeader = [[NearSectionView alloc]initWithFrame:CGRectMake(0,0, Screen_W, 0)];
    sectionHeader.itinerarieModel =_itinerModels[section];
    sectionHeader.sectiontIndex = section;
    sectionHeader.delegate = self;
    return sectionHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 15.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 10)];
    [footView setBackgroundColor:[UIColor clearColor]];
    UIView *footShowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 5)];
    footShowView.layer.shadowOpacity = 0.3;
    footShowView.layer.shadowOffset = CGSizeMake(5,5);
    footShowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [footShowView setBackgroundColor:[UIColor whiteColor]];
    [footView addSubview:footShowView];
    return footView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NearDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PathDetailViewController *pathVC = [[PathDetailViewController alloc]init];
    pathVC.itDetailModel = cell.itDetailFrameModel.itDetailModel;
    
    [self presentViewController:pathVC animated:YES completion:nil];
}


#pragma mark NearSectionDelegate
- (void)selectSectionAction:(id)sectionView{
    NearSectionView *tempV = (NearSectionView *)sectionView;
    ItinerarieModel *itmodel = tempV.itinerarieModel;
    
    if (!itmodel.selected) {
        [itmodel loadItinerarieDetails:^{
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:tempV.sectiontIndex];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];

    }else{
        itmodel.itinerarieDetails = nil;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:tempV.sectiontIndex];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    itmodel.selected = !itmodel.selected;
}

- (void)initNavgationBar{
    
    UIButton *NavleftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [NavleftButton setFrame:CGRectMake(0, 0, 38, 25)];
    
    [NavleftButton setTitle:@"返回" forState:UIControlStateNormal];
    NavleftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    NavleftButton.titleLabel.textColor = [UIColor whiteColor];
    NavleftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [NavleftButton addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:NavleftButton];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    
}

- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
