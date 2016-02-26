//
//  AdjustSliderNib.m
//  旅游季
//
//  Created by niit on 16/1/22.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "AdjustSliderNib.h"
#define Screen_H  [UIScreen mainScreen].bounds.size.height
#define Screen_W [UIScreen mainScreen].bounds.size.width
@implementation AdjustSliderNib

- (void)didHidden{
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame:CGRectMake(0, Screen_H, Screen_W, self.frame.size.height)];
    }];
    _isShow = NO;
}
- (void)didShow{
   
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:CGRectMake(0, Screen_H- 49-80-self.frame.size.height, Screen_W,self.frame.size.height)];
    }];
    _isShow = YES;
}
@end
