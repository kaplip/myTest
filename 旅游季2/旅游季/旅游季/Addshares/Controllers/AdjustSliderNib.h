//
//  AdjustSliderNib.h
//  旅游季
//
//  Created by niit on 16/1/22.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustSliderNib : UIView
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;


@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (assign, readonly, nonatomic) BOOL isShow;

- (void)didHidden;
- (void)didShow;

@end
