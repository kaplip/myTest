//
//  RootViewController.h
//  旅游季
//
//  Created by niit on 15/12/26.
//  Copyright © 2015年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITabBarController

@property (assign,readonly ,nonatomic) BOOL rootTabBarHidden;

- (void)hiddenTabBar:(BOOL)hidden andTransFormX:(CGFloat)transformX;

@end
