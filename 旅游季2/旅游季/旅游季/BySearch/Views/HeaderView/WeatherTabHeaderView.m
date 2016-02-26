//
//  WeatherTabHeaderView.m
//  旅游季
//
//  Created by niit on 16/1/15.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "WeatherTabHeaderView.h"
@interface WeatherTabHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tempImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@end


@implementation WeatherTabHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"WeatherTabHeaderView" owner:nil options:nil].lastObject;
    }
    return self;
}


- (void)setWeatherModel:(WeatherModel *)weatherModel{
    
    _weatherModel = weatherModel;
    
    _dateLabel.text = weatherModel.date;
    _locationLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:City_Name];
    _tempLabel.text = weatherModel.curTemp;
    
 
    _tempInfoLabel.text = [NSString stringWithFormat:@" %@  %@/%@",weatherModel.type,weatherModel.lowtemp,weatherModel.hightemp];
    _tempImageView.image = [UIImage imageNamed:weatherModel.weatherImageName];
    _weekLabel.text = weatherModel.week;
    _windLabel.text  = [NSString stringWithFormat:@"%@/%@",weatherModel.fengli,weatherModel.fengxiang];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
