//
//  ForecastAndHistoryModel.m
//  旅游季
//
//  Created by niit on 16/1/15.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ForecastAndHistoryModel.h"

@implementation ForecastAndHistoryModel

- (instancetype)initForeHisWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        self.weatherImageName = [self  weatherImageNameWithWeatherType:self.type];
    }
    return self;
}


@end
