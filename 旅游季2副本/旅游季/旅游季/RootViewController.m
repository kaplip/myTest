//
//  RootViewController.m
//  旅游季
//
//  Created by niit on 15/12/26.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "RootViewController.h"
#import "ProfileViewController.h"
#import "BySearchViewController.h"
#import "AddShareMessageVC.h"
#import "ConCommentVC.h"
#import "MyCenterVCViewController.h"

#define Bar_H 49
#define Screen_H  [UIScreen mainScreen].bounds.size.height
#define Screen_W  [UIScreen mainScreen].bounds.size.width
@interface RootViewController()<UITabBarDelegate>

@property(strong, nonatomic)UITabBar *rootTabber;

@end

@implementation RootViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    [self initRootTabBar];
    [self initControllers];
    
}
-(void)initRootTabBar{
    
    self.tabBar.hidden =YES;
    
    self.rootTabber = [[UITabBar alloc]initWithFrame:CGRectMake(0, Screen_H-Bar_H, Screen_W, Bar_H)];
    self.rootTabber.barStyle = UIBarStyleDefault;
    
    self.rootTabber.clipsToBounds = YES;
//    self.rootTabber.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Login"]];
    [self.rootTabber setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    self.rootTabber.delegate = self;
    
    NSArray *itemImageName  = @[@"Prefie_barButton",@"Bysearch_barButton",@"AddMessage",@"Isgood_barButton",@"Mycenter_barButton"];
    NSArray *itemTitle = @[@"首页",@"搜一搜",@"",@"推荐",@"我"];
    
    NSMutableArray *itemArrM = [[NSMutableArray alloc]initWithCapacity:itemTitle.count];
    
    for(int i = 0;i<5;i++){
        
        UIImage *itemImage = [UIImage imageNamed:itemImageName[i]];
        itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *item  = [[UITabBarItem alloc]initWithTitle:itemTitle[i] image:itemImage tag:i+100];
        [itemArrM addObject:item];
    }
    self.rootTabber.translucent = NO;
    self.rootTabber.itemPositioning = UITabBarItemPositioningCentered;
    self.rootTabber.items = [itemArrM copy];
    [self.view addSubview:self.rootTabber];
}

-(void)initControllers{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProfileViewController *proVC = [sb instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    BySearchViewController *searVC = [sb instantiateViewControllerWithIdentifier:@"BySearchViewController"];
  
    ConCommentVC *commmentVC = [sb instantiateViewControllerWithIdentifier:@"ConCommentVC"];
    MyCenterVCViewController *centerVC = [sb instantiateViewControllerWithIdentifier:@"MyCenterVC"];
    
    
    NSArray *controllers = @[proVC,searVC,[NSNull null],commmentVC,centerVC];
    
    NSMutableArray *navCArray =[[NSMutableArray alloc]initWithCapacity:controllers.count];;
    for (int i = 0; i<5; i++) {
        if (i!=2) {
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controllers[i]];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setBarStyle:UIBarStyleBlack];
            
            [navCArray addObject:nav];
        }
    }
    
    self.viewControllers =[navCArray copy];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if (item.tag == 102) {
        
         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          AddShareMessageVC *addVC = [sb instantiateViewControllerWithIdentifier:@"AddShareMessageVC"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addVC];
        addVC.navigationController.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:^{
            addVC.navigationController.navigationBar.hidden = NO;
        }];
    }else if(item.tag < 102){
          self.selectedIndex = item.tag-100;
    }else {
        self.selectedIndex = item.tag-101;
    }
}

- (void)hiddenTabBar:(BOOL)hidden andTransFormX:(CGFloat)transformX{
    
    if (hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.rootTabber.transform = CGAffineTransformTranslate(self.rootTabber.transform, -Screen_W, 0);
        }];
    }else{
      [UIView animateWithDuration:0.2 animations:^{
            self.rootTabber.transform = CGAffineTransformIdentity;
      }];

    }
    _rootTabBarHidden = hidden;
}


-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}
@end
