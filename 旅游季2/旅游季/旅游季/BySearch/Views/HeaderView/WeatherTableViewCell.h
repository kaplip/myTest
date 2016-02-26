//
//  WeatherTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/16.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherIndexModel;
@interface WeatherTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (strong, nonatomic) WeatherIndexModel *indexModel;

@end
