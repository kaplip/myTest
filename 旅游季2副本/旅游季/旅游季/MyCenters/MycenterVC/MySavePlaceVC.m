//
//  MySavePlaceVC.m
//  旅游季
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "MySavePlaceVC.h"
#import "PathDetailModel.h"
#import "PathDetailTableViewCell.h"

@interface MySavePlaceVC ()

@property (strong, nonatomic) NSMutableArray *pathModelArr;

@end

@implementation MySavePlaceVC

- (NSMutableArray *)pathModelArr{
    
    if (_pathModelArr==nil) {
        _pathModelArr = [[NSMutableArray alloc]init];
    }
    return _pathModelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationBar];
    [self loadArr];

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
    titleLabel.text = self.centerSortTitle;
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)loadArr{
    NSDate *date = [NSDate date];
    [PathDetailModel loadMyFavPathDetailWtihDate:date result:^(id result) {
        NSArray *arr = (NSArray *)result;
        [self.pathModelArr addObjectsFromArray: arr];
        [self.tableView  reloadData];
        [self fetchCellImage];
    }];
    
}

- (void)fetchCellImage{
    
    for (int i = 0; i<self.pathModelArr.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        PathDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        PathDetailModel *pathDetail  = self.pathModelArr[i];
        [pathDetail fetchImageDataCompelete:^(id result) {
            cell.pathDetail = pathDetail;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.pathModelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"pathDetail";
    PathDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[PathDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // Configure the cell...
    cell.pathDetail = self.pathModelArr[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 346;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)returnMyCenter{
    
    [self.navigationController popViewControllerAnimated: YES];
}

@end
