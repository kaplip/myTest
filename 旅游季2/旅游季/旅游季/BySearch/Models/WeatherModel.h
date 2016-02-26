//
//  WeatherModel.h
//  旅游季
//
//  Created by niit on 16/1/15.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ WeatherInfo) (id resultArr);
@interface WeatherModel : NSObject

@property (copy, nonatomic) NSString *updateTime;

@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *week;
@property (copy, nonatomic) NSString *curTemp;//当前温度
@property (copy, nonatomic) NSString *aqi;//pm值
@property (copy, nonatomic) NSString *fengxiang;
@property (copy, nonatomic) NSString *fengli;
@property (copy, nonatomic) NSString *hightemp;
@property (copy, nonatomic) NSString *lowtemp;

@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *weatherImageName;

@property (strong, nonatomic) NSArray *index;
@property (strong, nonatomic) NSArray *weatherIndexArr;


@property (strong, nonatomic) NSArray *forecastInfo;
@property (strong, nonatomic) NSArray *historyInfo;

@property (strong, nonatomic) NSString *backImageName;

+ (void)getWeatherInfo:(WeatherInfo)resultArr;
+ (NSString *)hexStringFromString:(NSString *)string;


- (NSString *)weatherImageNameWithWeatherType:(NSString *)weatherType;
@end
