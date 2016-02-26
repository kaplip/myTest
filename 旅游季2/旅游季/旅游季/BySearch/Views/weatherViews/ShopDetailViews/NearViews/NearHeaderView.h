//
//  NearHeaderView.h
//  旅游季
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityModel;
@interface NearHeaderView : UIView

@property (strong, nonatomic) CityModel *cityModel;
@property (assign, nonatomic) CGFloat headerHeight;
- (instancetype)initWithFrame:(CGRect)frame;

@end
