//
//  FoodDetailViewController.m
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "DealDetailTableViewCell.h"

#import "ShopDetailHeaderView.h"
#import "ShopDetailModel.h"
#import "ShopModel.h"

#import "DealFrameModel.h"
#import "DealModel.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface FoodDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ShopDetailLookForDelegate>

@property (strong, nonatomic) ShopDetailHeaderView *headerView;
@property (strong, nonatomic) ShopDetailModel *detailModel;
@property (strong, nonatomic) UITableView *tabview;
@end

@implementation FoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationBar];
    // Do any additional setup after loading the view.
    [self initTabView];
    [ShopDetailModel fetchShopDetailInfoWithId:_shopModel.shop_id andresult:^(id shopDetail) {
        _detailModel =  shopDetail;
        _detailModel.titleImageData = _shopModel.titleImageData;
        _headerView.shopDetailModel = self.detailModel;
    }];
}

- (void)initTabView{
    self.tabview  = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _headerView = [[ShopDetailHeaderView alloc]initWithFrame:self.view.frame];
    self.tabview.tableHeaderView =_headerView;

    self.tabview.delegate  =self;
    self.tabview.dataSource = self;
    _headerView.delegate = self;
    
    self.tabview.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tabview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 3.0>_shopModel.dealsModelArr.count?_shopModel.dealsModelArr.count:3.0;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"detailCell";
    DealDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[DealDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    DealFrameModel *frameModel = [[DealFrameModel alloc]init];
    DealModel *dealModel = self.shopModel.dealsModelArr[indexPath.row];
    frameModel.dealModel = dealModel;

    cell.dealFrameModel = frameModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DealFrameModel *frameModel = [[DealFrameModel alloc]init];
    DealModel *dealModel = self.shopModel.dealsModelArr[indexPath.row];
    frameModel.dealModel = dealModel;
    
    return frameModel.cellHeight;
}


- (void)lookforShopOnMap:(UIButton *)sender{
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
