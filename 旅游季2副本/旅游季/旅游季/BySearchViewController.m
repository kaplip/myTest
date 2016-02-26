//
//  BySearchViewController.m
//  旅游季
//
//  Created by niit on 15/12/26.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "BySearchViewController.h"
#import "BySearchHeaderView.h"
#import "CustomCell.h"
#import "SearchTabelCellTableViewCell.h"
#import "BySearchModel.h"

#import "RootViewController.h"
#import "MapViewController.h"
#import "FoodSearchTableViewController.h"
#import "WeatherViewController.h"
#import "NearSearchTableViewController.h"

#import "SearchDetailViewController.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width
#define ScreenH   [UIScreen mainScreen].bounds.size.height

@interface BySearchViewController()<ChoiceSortDelegate>

@property (strong,nonatomic) NSMutableArray *sortViewControllers;
@property (strong, nonatomic) NSArray *searchInfoArr;

@end

@implementation BySearchViewController

static NSString *reuseIdentifier = @"SearchCell";
- (void)viewDidLoad{
    [super viewDidLoad];

    [self initTableHeader];
    
    [self.tableView setFrame:CGRectMake(0, 0, ScreenW, ScreenH-49)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SearchTabelCellTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    [self.view.layer addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
   
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
    [self loadInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    
    RootViewController *rootTabBar = (RootViewController *)self.navigationController.tabBarController;
    if (rootTabBar.rootTabBarHidden) {
        [rootTabBar hiddenTabBar:NO andTransFormX:self.view.layer.position.x];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_sortViewControllers) {
        [_sortViewControllers removeAllObjects];
        _sortViewControllers = nil;
    }
  
}
- (void)initTableHeader{
    BySearchHeaderView *header = [[BySearchHeaderView alloc]initWithFrame:CGRectMake(0, 0,ScreenW, 295)];
    
    header.sortDelegate = self;
    [header initUI];
    
    self.tableView.tableHeaderView = header;
}

- (void)loadInfo{
    
    NSDate *currentDate = [NSDate date];
    
    [BySearchModel loadSearchInfoWithDate:currentDate andResult:^(id result) {
        self.searchInfoArr = result;
        [self.tableView reloadData];
    }];
    
}

#pragma  mark UItableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTabelCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    BySearchModel *model = self.searchInfoArr[indexPath.row];
    
    
    cell.searchModel = model;
    
    return  cell;
}

#pragma mark UItableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTabelCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    SearchDetailViewController *searchDetailVC = [[SearchDetailViewController alloc]init];
    
    searchDetailVC.searchModel = cell.searchModel;
    
    [self.navigationController pushViewController:searchDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    RootViewController *rootTabBar = (RootViewController *)self.navigationController.tabBarController;
    [rootTabBar hiddenTabBar:YES andTransFormX:0.0];
}



- (NSMutableArray *)sortViewControllers{
    
    if (_sortViewControllers==nil) {
        _sortViewControllers = [NSMutableArray array];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MapViewController *mapVC = [sb instantiateViewControllerWithIdentifier:@"MapViewController"];
        FoodSearchTableViewController *foodVC = [sb instantiateViewControllerWithIdentifier:@"FoodSearchViewController"];
        WeatherViewController *weaherVC = [sb instantiateViewControllerWithIdentifier:@"WeatherViewController"];
        NearSearchTableViewController *nearVC = [sb instantiateViewControllerWithIdentifier:@"NearSearchViewController"];
     
        [_sortViewControllers addObject:mapVC];
        [_sortViewControllers addObject:weaherVC];
        [_sortViewControllers addObject:foodVC];
        [_sortViewControllers addObject:nearVC];
    }
    return _sortViewControllers;
}

#pragma  mark ChoiceSortDelegate
- (void)didChoiceSort:(CustomCell *)sort{
    
    UIViewController *tempViewVC = self.sortViewControllers[sort.sortTag-100];
    RootViewController *rootTabBar = (RootViewController *)self.navigationController.tabBarController;
    [rootTabBar hiddenTabBar:YES andTransFormX:0.0];
    tempViewVC.title = sort.sortTitle;
   
    [self.navigationController pushViewController:tempViewVC animated:YES];
    
    NSLog(@"%@",sort.sortTitle);
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
  
}

@end
