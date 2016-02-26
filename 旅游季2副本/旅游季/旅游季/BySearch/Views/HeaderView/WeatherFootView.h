//
//  WeatherFootView.h
//  旅游季
//
//  Created by niit on 16/1/16.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherModel;
@interface WeatherFootView : UIView


- (CGFloat)getviewMaxH;
@property (strong, nonatomic) WeatherModel *weatherModel;

@end
