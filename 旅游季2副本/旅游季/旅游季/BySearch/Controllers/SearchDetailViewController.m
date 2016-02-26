//
//  SearchDetailViewController.m
//  旅游季
//
//  Created by niit on 16/2/21.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "UIImageView+WebCache.h"
#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface SearchDetailViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *headerV;
@property (strong,nonatomic) UILabel *contentL;
@property (strong, nonatomic) UILabel *titleL;

@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationBar];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setSearchModel:(BySearchModel *)searchModel{

    _searchModel = searchModel;
    [self initScroView];
    [self setScrollView];
    
    [_headerV sd_setImageWithURL: [NSURL URLWithString:_searchModel.imageUrl]];
    [_titleL setText:_searchModel.title];
    
    [_contentL setText:_searchModel.content];
    [_contentL setFont:[UIFont systemFontOfSize:15]];
    [_contentL setNumberOfLines:0];
    [_contentL setTextColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize sourceSize = CGSizeMake(Screen_W, MAXFLOAT);
    CGSize reusltSize = [_searchModel.content boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    CGFloat headerV_Y = CGRectGetMaxY(_headerV.frame)+10;
    
    [_contentL setFrame:CGRectMake(0, headerV_Y, Screen_W, reusltSize.height)];
    
    CGFloat contentL_Y = CGRectGetMaxY(_contentL.frame);
    [_scrollView setContentSize:CGSizeMake(0, contentL_Y)];
}

- (void)initScroView{
    _scrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_scrollView];
}

- (void)setScrollView{
    
    _headerV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,Screen_W,180)];
    _titleL  = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, Screen_W, 50)];
    [_titleL setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [_titleL setFont:[UIFont systemFontOfSize:15]];
    [_titleL setTextColor:[UIColor whiteColor]];
    
    
    _contentL  = [[UILabel alloc]init];
    [self.scrollView addSubview:_headerV];
    [_headerV addSubview:_titleL];
    [self.scrollView addSubview:_contentL];
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
