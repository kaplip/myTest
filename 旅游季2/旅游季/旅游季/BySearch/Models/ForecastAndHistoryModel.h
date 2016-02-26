//
//  ForecastAndHistoryModel.h
//  旅游季
//
//  Created by niit on 16/1/15.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "WeatherModel.h"

@interface ForecastAndHistoryModel : WeatherModel



- (instancetype)initForeHisWithDict:(NSDictionary *)dict;

@end
