//
//  FoodTabFootView.m
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//


#import "FoodTabFootView.h"


@interface FoodTabFootView()



@end

@implementation FoodTabFootView

-  (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"FoodTabFootView" owner:nil options:nil].lastObject;
       
    }
    
    return self;
}

- (void)awakeFromNib{
    
    [self.loadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
    self.loadMoreButton.titleLabel.textColor = [UIColor whiteColor];
    [self.loadMoreButton setBackgroundColor:[UIColor orangeColor]];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)loadMoreAction:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    [tempButton setTitle:@"加载中..." forState:UIControlStateNormal];
    if (self.loadDelegate && [self.loadDelegate respondsToSelector:@selector(loadModreAction:)]) {
        [self.loadDelegate loadModreAction:sender];
    }
    
}
@end
