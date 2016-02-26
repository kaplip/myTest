//
//  WeatherViewController.m
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherModel.h"
#import "WeatherTabHeaderView.h"
#import "WeatherIndexModel.h"
#import "WeatherTableViewCell.h"
#import "WeatherFootView.h"
#import "MBProgressHUD.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width

@interface WeatherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) WeatherModel *weatherModel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property (strong, nonatomic) IBOutlet UITableView *weatherTab;

@end

@implementation WeatherViewController

static NSString *identifier = @"indexCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavgationBar];
    [self.weatherTab registerClass:[WeatherTableViewCell class] forCellReuseIdentifier:identifier];
    
    self.weatherTab.delegate = self;
    self.weatherTab.dataSource = self;
    self.weatherTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [WeatherModel getWeatherInfo:^(id resultInfo) {
        _weatherModel = resultInfo;
        [_backgroundImageView setImage:[UIImage imageNamed:_weatherModel.backImageName]];
        _backgroundImageView.image = [UIImage imageNamed:_weatherModel.backImageName];
        [self setupUI];
        [self.weatherTab reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    
    WeatherTabHeaderView *headerView = [[WeatherTabHeaderView alloc]initWithFrame:CGRectMake(0, 0,ScreenW , 300)];
    headerView.weatherModel = self.weatherModel;
    
    WeatherFootView *tabfootView =[[WeatherFootView alloc]init];
    tabfootView.backgroundColor = [UIColor clearColor];
    tabfootView.weatherModel = self.weatherModel;
    [tabfootView setFrame:CGRectMake(0, 0, ScreenW, [tabfootView getviewMaxH])];
    
    self.weatherTab.tableFooterView = tabfootView;
    self.weatherTab.tableHeaderView = headerView;
    self.weatherTab.backgroundColor = [UIColor clearColor];
}



#pragma mark UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.weatherModel.weatherIndexArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    WeatherIndexModel *indexModel = self.weatherModel.weatherIndexArr[indexPath.row];
    
    cell.indexModel = indexModel;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
