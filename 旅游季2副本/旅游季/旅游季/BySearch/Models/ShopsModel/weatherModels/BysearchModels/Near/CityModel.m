//
//  CityModel.m
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "CityModel.h"
#import "ItinerarieModel.h"
@implementation CityModel

+ (void)fetchDataWithCityName:(NSString *)cityName complete:(CompeleteFetch)result{
    
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];

    NSString *httpUrl =[NSString stringWithFormat:@"http://apis.baidu.com/apistore/travel/line?location=%@&day=all&output=json&coord_type=bd09ll&out_coord_type=bd09ll",[CityModel hexStringFromString:cityName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:httpUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    request.HTTPMethod = @"GET";
    [request addValue:@"9655d443a863591ef017472bd6094f68" forHTTPHeaderField:@"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"旅游城市请求失败，erro = %@",error);
        }else {
            
            NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            CityModel *cityModel = [[CityModel alloc]initWithDict:dict[@"result"]];
            
            [cityModel fetchImageWithCityName:cityModel fetchOP:result];
        }
    }];
    [task resume];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *temDict in _itineraries) {
            ItinerarieModel *itinerarieModel = [[ItinerarieModel alloc]initWithDict:temDict];
            itinerarieModel.cityname = _cityname;
            [arrM addObject:itinerarieModel];
        }
        _itinerariModels  = [arrM copy];
    
    }
    return self;
}

- (void)fetchImageWithCityName:(CityModel *)city fetchOP:(CompeleteFetch)result{
    
    NSString *httpUrl = @"http://apis.baidu.com/image_search/search/search";
    NSString *httpArg = [NSString stringWithFormat:@"word=%@&pn=0&rn=1&ie=utf-8",[CityModel hexStringFromString:city.cityname]];
    NSString *httpReStr = [NSString stringWithFormat:@"%@?%@",httpUrl,httpArg];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:httpReStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    request.HTTPMethod = @"GET";
    [request addValue:@"9655d443a863591ef017472bd6094f68" forHTTPHeaderField:@"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error = %@",error);
        }else{
            NSDictionary * resultDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSURL *imageUrl  =[NSURL URLWithString:[resultDict[@"data"][@"ResultArray"] firstObject][@"ObjUrl"]] ;

            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            city.imageData = imageData;
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                result(city);
            }];
        }
    }];
    [datatask resume];
    
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
