//
//  GotoWayTableViewController.m
//  旅游季
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "GotoWayTableViewController.h"

#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface GotoWayTableViewController ()


@end

@implementation GotoWayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.destinationPoint.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"destinationPoint";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    BMKPoiInfo *info = self.destinationPoint[indexPath.row];
    cell.textLabel.text = info.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.findWaydelegate && [self.findWaydelegate respondsToSelector:@selector(gotoWayByBMKPoiInfo:)]) {
        BMKPoiInfo *info = self.destinationPoint[indexPath.row];
        
        [self.findWaydelegate gotoWayByBMKPoiInfo:info.pt];
        [self.navigationController popViewControllerAnimated:YES];
    }
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

@end
