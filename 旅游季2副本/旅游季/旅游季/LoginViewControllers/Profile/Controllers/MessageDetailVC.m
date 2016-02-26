//
//  MessageDetailVC.m
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "MessageDetailVC.h"
#import "MessageDetaileHeader.h"
#import "RootViewController.h"
#import "MessageDetailFootView.h"
#import "CritiqueModel.h"
#import "CritiqueCellFrame.h"
#import "Bmob+BmobDataModelTool.h"
#import "CritiqueCellTableViewCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
@interface MessageDetailVC ()<EndEditDelegate,sendCritiqueDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *detailMessageTab;
@property (strong, nonatomic) UIToolbar *toolBar;

@property (strong, nonatomic) NSArray *critiqueArr;
@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationBar];
    [self initDetailMessageTab];
    [self initHeaderV];
    [self initfootV];
    [self loadCritique];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, 0, 0, 0)];
    [self setupRefresh];
    
    // Do any additional setup after loading the view.
}

- (void)initNavgationBar{
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    [returnButton setFrame:CGRectMake(0, 0, 45, 45)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:returnButton];
    self.navigationItem.leftBarButtonItem = item;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    titleLabel.text = @"动态详情";
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    RootViewController *rootTabBar = (RootViewController *)self.navigationController.tabBarController;
    [rootTabBar hiddenTabBar:YES andTransFormX:0.0];

}

- (void)viewWillDisappear:(BOOL)animated{
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


NSString *identifier = @"critiqueCell";

- (void)initDetailMessageTab{
    
    _detailMessageTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49) style:UITableViewStylePlain];
    [self.view addSubview:_detailMessageTab];
    [self.detailMessageTab registerClass:[CritiqueCellTableViewCell class] forCellReuseIdentifier:identifier];
    
      [_detailMessageTab addHeaderWithTarget:self action:@selector(loadCritique)];
    _detailMessageTab.dataSource = self;
    _detailMessageTab.delegate = self;
}

- (void)setupRefresh{
    self.detailMessageTab.headerPullToRefreshText = @"加载更多...";
    self.detailMessageTab.headerReleaseToRefreshText = @"松开我...";
    self.detailMessageTab.headerRefreshingText = @"努力加载中...";
}

- (void)initHeaderV{
    MessageDetaileHeader *header = [[MessageDetaileHeader alloc]initWithShareModel:self.shareModel];
    header.delegate = self;
    _detailMessageTab.tableHeaderView = header;
}
- (void)endEditingAction{
    MessageDetailFootView *footV = ( MessageDetailFootView *)_detailMessageTab.tableFooterView;
    [footV endEditing:YES];
}

- (void)initfootV{
    MessageDetailFootView *footV = [[MessageDetailFootView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    footV.delegate = self;
    _detailMessageTab.tableFooterView = footV;
}

- (void)sendCritiqueAction:(NSString *)content{
    
    CritiqueModel *critiqueModel = [[CritiqueModel alloc]init];
    critiqueModel.userModel = [UserModel sharedUserModel];
    critiqueModel.shareModel = _shareModel;
    critiqueModel.content = content;
    
    [Bmob inseterCritiqueModel:critiqueModel];
    
}

- (void)loadCritique{
    
    [CritiqueModel loadCritiqueWithShareModel:_shareModel andResult:^(id result) {
        NSArray *arr = (NSArray *)result;
        NSMutableArray *frameModelArr = [[NSMutableArray alloc]init];
        
        for (CritiqueModel *model in arr) {
            CritiqueCellFrame *frameModel = [[CritiqueCellFrame alloc]init];
            frameModel.critiqueModel = model;
            [model findUserInfoWithObjectId:model.objectId andResult:^(id result) {
                 [_detailMessageTab reloadData];
            }];
            [frameModelArr addObject:frameModel];
           
        }
        
        _critiqueArr =[frameModelArr copy];
         [_detailMessageTab reloadData];
         [self.detailMessageTab headerEndRefreshing];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.critiqueArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CritiqueCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    CritiqueCellFrame *frameModel = self.critiqueArr[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CritiqueCellFrame *frameModel = self.critiqueArr[indexPath.row];
    
    return frameModel.cell_height;
}

- (void)commitAction{
    
    [MBProgressHUD showMessage:@"正在提交举报"];
    [self performSelector:@selector(endCommtiAction) withObject:nil afterDelay:0.5];
    
}
- (void)endCommtiAction{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"举报成功"];

}

@end
