//
//  WeatherIndexModel.m
//  旅游季
//
//  Created by niit on 16/1/15.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "WeatherIndexModel.h"

@implementation WeatherIndexModel

- (instancetype)initWeatherModelWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        if ([_index isEqualToString:@""]) {
            _index = @"较强";
        }
        
    }
    return self;
}

@end
