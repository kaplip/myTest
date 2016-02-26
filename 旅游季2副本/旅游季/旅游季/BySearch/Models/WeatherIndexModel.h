//
//  WeatherIndexModel.h
//  旅游季
//
//  Created by niit on 16/1/15.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherIndexModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *index;
@property (copy, nonatomic) NSString *details;
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *otherName;

- (instancetype)initWeatherModelWithDict:(NSDictionary *)dict;

@end
