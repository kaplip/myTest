//
//  AboutUsViewController.m
//  旅游季
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "AboutUsViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface AboutUsViewController ()

@property (strong, nonatomic) NSString *remind;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavgationBar];
    [self initScrollView];
    [self initLabel];
   
    // Do any additional setup after loading the view.
}

- (void)initLabel{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"AboutUs" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    _label = [[UILabel alloc]init];
    UIFont *font =[UIFont systemFontOfSize:15];
    _label.font =font;
    _label.textColor = [UIColor blackColor];
    _label.text  = dict[@"aboutUs"];
    _label.numberOfLines = 0;
    
    CGSize sourceSize =CGSizeMake(self.scrollView.frame.size.width-10, MAXFLOAT)  ;
    CGSize resultSize = [_label.text boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    [_label setFrame:CGRectMake(5, 0, ScreenW-5, resultSize.height)];
    [self.scrollView setContentSize:CGSizeMake(0, resultSize.height)];
    [self.scrollView addSubview:_label];
}

- (void)initScrollView{
    CGFloat nav_Y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - nav_Y)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_scrollView];
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
    
    [leftButton addTarget:self action:@selector(returnMyCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    titleLabel.text = self.messageDetailTitle;
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)returnMyCenter{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
