//
//  WeatherModel.m
//  旅游季
//
//  Created by niit on 16/1/15.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "WeatherModel.h"
#import "ForecastAndHistoryModel.h"
#import "WeatherIndexModel.h"
@implementation WeatherModel

+ (void)getWeatherInfo:(WeatherInfo)resultArr{
    
    NSString *provience = [[NSUserDefaults standardUserDefaults]objectForKey:AdministrativeArea];
    NSString *cityName = [[NSUserDefaults standardUserDefaults]objectForKey:City_Name];
    provience = [provience stringByReplacingOccurrencesOfString:@"省" withString:@""];
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    NSString *hex_cityName=[WeatherModel hexStringFromString:cityName];
    
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/citylist";
    NSString *httpArg = [NSString stringWithFormat:@"cityname=%@",hex_cityName];
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue: @"9655d443a863591ef017472bd6094f68" forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                                   } else {
                                       NSDictionary *result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                       NSArray *cityArr = result[@"retData"];
                                       for (NSDictionary *dict in cityArr) {
                                           if ([dict[@"province_cn"]isEqualToString:provience]) {
                                               if ([dict[@"district_cn"]isEqualToString:cityName]) {
                                                   
                                                   [WeatherModel requestWeatherInfoWithcityName:dict[@"district_cn"] cityID:dict[@"area_id"] weatherInfo:resultArr];
                                                   
                                               }
                                           }
                                       }
                                       
                                   }
                               }];
}

+ (void)requestWeatherInfoWithcityName:(NSString *)cityName cityID:(NSString *)cityID weatherInfo:(WeatherInfo)resultInfo {
    NSString *httpUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    NSString *hex_cityName = [WeatherModel hexStringFromString:cityName];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?cityname=%@&cityid=%@",httpUrl,hex_cityName,cityID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"9655d443a863591ef017472bd6094f68" forHTTPHeaderField:@"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error = %@",error);
        }else{
            
            NSDictionary *result = ( NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *weather = result[@"retData"];
          
            WeatherModel *weatherModel = [[WeatherModel alloc]initWithDict:weather];

            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                resultInfo(weatherModel);
            }];   
        }
    }];
    [task resume];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict[@"today"]];
        _weatherImageName = [self weatherImageNameWithWeatherType:_type];
        _weatherIndexArr = [self getWeatherIndexArrWithDic:_index];
        _forecastInfo = [self getWeatherForecastArrWithArr:dict[@"forecast"]];
        _historyInfo = [self getWeatherHistoryArrWithArr:dict[@"history"]];
    }
    return self;
}

- (NSArray *)getWeatherIndexArrWithDic:(NSArray *)arr{
    NSMutableArray *arrM = [[NSMutableArray alloc]initWithCapacity:arr.count];
    
    for (NSDictionary *dict in arr) {
        WeatherIndexModel *weatherIndexModel = [[WeatherIndexModel alloc]initWeatherModelWithDict:dict];
        [arrM addObject:weatherIndexModel];
    }
    return [arrM copy];
}


- (NSArray *)getWeatherForecastArrWithArr:(NSArray *)arr{
     NSMutableArray *arrM = [[NSMutableArray alloc]initWithCapacity:arr.count];
     for (NSDictionary *dict in arr) {
        ForecastAndHistoryModel *foreHisModel = [[ForecastAndHistoryModel alloc]initForeHisWithDict:dict];
        [arrM addObject:foreHisModel];
    }
    return [arrM copy];
}


- (NSArray *)getWeatherHistoryArrWithArr:(NSArray *)arr{
    NSMutableArray *arrM = [[NSMutableArray alloc]initWithCapacity:arr.count];
    for (NSDictionary *dict in arr) {
        ForecastAndHistoryModel *foreHisModel = [[ForecastAndHistoryModel alloc]initForeHisWithDict:dict];
        [arrM addObject:foreHisModel];
    }
    return [arrM copy];
}


- (NSString *)weatherImageNameWithWeatherType:(NSString *)weatherType{
    NSString *weatherName;
    if ([weatherType isEqualToString:@"晴"]) {
        weatherName = @"sunny";
       _backImageName =  @"backSunny";
    }
    if ([weatherType isEqualToString:@"多云"]) {
        weatherName = @"cloudy";
        _backImageName =  @"backOther";
    }
    if ([weatherType isEqualToString:@"阴"]) {
        weatherName = @"overcast";
        _backImageName = @"backOvercast";
    }

    if ([weatherType isEqualToString:@"阵雨"]) {
        weatherName = @"shower";
        _backImageName = @"backRain";
    }
   
    if ([weatherType isEqualToString:@"雷阵雨"]||
        [weatherType isEqualToString:@"雷阵雨伴有冰雹"]) {
        weatherName = @"shower";
        _backImageName = @"backRain";
    }
    if ([weatherType isEqualToString:@"雨夹雪"]) {
        weatherName = @"snowrain";
        _backImageName = @"backRain";
    }
    
    if ([weatherType isEqualToString:@"小雨"]||
        [weatherType isEqualToString:@"小到中雨"]
        ) {
        weatherName = @"lightRain";
        _backImageName = @"backRain";
    }
    if ([weatherType isEqualToString:@"大雨"]||
        [weatherType isEqualToString:@"暴雨"]||
        [weatherType isEqualToString:@"中到大雨"]) {
        weatherName = @"heavyrain";
        _backImageName = @"backRain";
    }
    if ([weatherType isEqualToString:@"大暴雨"]||
        [weatherType isEqualToString:@"特大暴雨"]||
        [weatherType isEqualToString:@"暴雨到大暴雨"]||
        [weatherType isEqualToString:@"大暴雨到特大暴雨"]) {
        weatherName = @"thunderStorm";
        _backImageName = @"backRain";
    }
    if ([weatherType isEqualToString:@"阵雪"]) {
        weatherName = @"snowflurry";
        _backImageName = @"backSnow";
    }
    if ([weatherType isEqualToString:@"小雪"]||
        [weatherType isEqualToString:@"中雪"]||
        [weatherType isEqualToString:@"冻雨"]||
        [weatherType isEqualToString:@"小到中雪"]) {
        weatherName = @"lightSnow";
         _backImageName = @"backSnow";
    }
    if ([weatherType isEqualToString:@"大雪"]||
        [weatherType isEqualToString:@"暴雪"]||
        [weatherType isEqualToString:@"中到大雪"]||
        [weatherType isEqualToString:@"大到暴雪"]) {
        weatherName = @"snow";
         _backImageName = @"backSnow";
    }
    if ([weatherType isEqualToString:@"浮尘"]||
        [weatherType isEqualToString:@"扬沙"]||
        [weatherType isEqualToString:@"强沙尘暴"]||
        [weatherType isEqualToString:@"霾"]) {
        weatherName = @"foggy";
        _backImageName = @"backOther";
    }
    
    return weatherName;
}


+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"\%";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    
        if (i<[myD length]-1) {
            hexStr = [NSString stringWithFormat:@"%@%%",hexStr];
        }
        
    } 
    return hexStr;
}
@end
