//
//  FoodSearchTableViewController.m
//  旅游季
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "FoodSearchTableViewController.h"
#import "ShopModel.h"
#import "FoodSearchTableViewCell.h"
#import "FoodTabFootView.h"

#import "FoodDetailViewController.h"
#import "MBProgressHUD+MJ.h"

#define Screen_W  [UIScreen mainScreen].bounds.size.width
#define Screen_H  [UIScreen mainScreen].bounds.size.height

typedef void (^Compelete)();

@interface FoodSearchTableViewController ()<LoadMoreActionDelaegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UISegmentedControl *searchSegment;

@property (strong, nonatomic) NSMutableArray *shopArr;


@property (strong, nonatomic) UITableView *tableView;
@end

@implementation FoodSearchTableViewController{
    
    int _pageIndex;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initNavgationBar];
    _pageIndex = 1;
    [self loadShopModelArrWithIndex:_pageIndex compelete:^{
        
    }];
    
    [self.tabBarController.tabBar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0)];
    
    [self initSegment];
    
    self.searchSegment.selectedSegmentIndex = 1;
    
    [self initFootView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadFoodErro) name:@"loadFoodInfoErro" object:nil];
    
}
- (void)initTableView{
   
    CGFloat navBarHeight = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-navBarHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
}

- (void)initFootView{
    
    FoodTabFootView *footView = [[FoodTabFootView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = footView;
    footView.loadDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initSegment{
    
    NSArray *items = @[@"周边",@"城市"];
    _searchSegment = [[UISegmentedControl alloc]initWithItems:items];
    [_searchSegment setFrame:CGRectMake(0, 0, 100, 30)];
    [_searchSegment setTintColor:[UIColor whiteColor]];
    [_searchSegment addTarget:self action:@selector(segmentValueChage:) forControlEvents:UIControlEventValueChanged ];
    
    
    self.navigationItem.titleView = _searchSegment;
}


- (void)segmentValueChage:(UISegmentedControl *)tempSeg{
    
    NSLog(@"%li",(long)tempSeg.selectedSegmentIndex);
    
}


- (NSMutableArray *)shopArr{
    
    if (_shopArr==nil) {
        _shopArr = [[NSMutableArray alloc]init];
    }
    return _shopArr;
}

- (void)loadShopModelArrWithIndex:(int)index compelete:(Compelete)comp{
    
    NSString *cityname = [[NSUserDefaults standardUserDefaults]objectForKey:City_Name];
    
    [ShopModel getShopModelWithCity:cityname withIndex:index result:^(id shopResultArr) {
        NSArray *tempArr = (NSArray *)shopResultArr;
        [self.shopArr addObjectsFromArray:tempArr];
        [self.tableView reloadData];
        comp();
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.shopArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ShopCell";
    FoodSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    if (cell==nil) {
        cell = [[FoodSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    ShopModel *model = self.shopArr[indexPath.row];

    cell.shopModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 87;
    
}

- (void)loadModreAction:(UIButton *)tempButton{
    
    _pageIndex+=1;
    [self loadShopModelArrWithIndex:_pageIndex compelete:^{
        [tempButton setTitle:@"加载更多" forState:UIControlStateNormal];
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodSearchTableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    
    FoodDetailViewController *foodDetailVC = [[FoodDetailViewController alloc]init];
    
    foodDetailVC.shopModel = cell.shopModel;
    
    [self.navigationController pushViewController:foodDetailVC animated:YES];
    
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


- (void)loadFoodErro{
    
    FoodTabFootView *footView = (FoodTabFootView *) self.tableView.tableFooterView;
    [footView.loadMoreButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [MBProgressHUD showError:@"加载失败"];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
