//
//  PathDetailViewController.m
//  旅游季
//
//  Created by niit on 16/1/21.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "PathDetailViewController.h"
#import "ItinerarieDetailModel.h"
#import "PathDetailTableViewCell.h"
#import "PathDetailModel.h"
#import "MBProgressHUD+MJ.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface PathDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *pathDetailTab;

@end

@implementation PathDetailViewController

- (void)setItDetailModel:(ItinerarieDetailModel *)itDetailModel{
    
    if (_itDetailModel==nil) {
        _itDetailModel = itDetailModel;
        
        for (int i =0;i<_itDetailModel.pathDetailModel.count;i++) {
            PathDetailModel *pathDetailM =_itDetailModel.pathDetailModel[i];
            [pathDetailM fetchImageDataCompelete:^(id result) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
                PathDetailTableViewCell *cell = [self.pathDetailTab cellForRowAtIndexPath:indexpath];
                cell.pathDetail = pathDetailM;
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPathDetailTab];
    [self initCancellButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aleadySaveAction) name:@"AleadySavePalce" object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initCancellButton{
    
    UIButton *cancellBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancellBut setFrame:CGRectMake((ScreenW-30)/2, ScreenH - 40, 30, 30)];
    [cancellBut setBackgroundImage:[UIImage imageNamed:@"cancellButton"] forState:UIControlStateNormal];
    [cancellBut addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:cancellBut aboveSubview:_pathDetailTab];
}

- (void)initPathDetailTab{
    
    
    CGRect tabR = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _pathDetailTab = [[UITableView alloc]initWithFrame:tabR style:UITableViewStyleGrouped];
    _pathDetailTab.delegate = self;
    _pathDetailTab.dataSource = self;
    
    [self.view addSubview:_pathDetailTab];
    
}

- (void)popAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark uitabView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.itDetailModel.pathDetailModel.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 346;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"pahtDetailCell";
    PathDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[PathDetailTableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
    }
    
    PathDetailModel *pathDetailModel = self.itDetailModel.pathDetailModel[indexPath.section];
    cell.pathDetail = pathDetailModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.pathDetailTab deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

- (void)aleadySaveAction{
    
    [MBProgressHUD showError:@"该地点已收藏"];
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
