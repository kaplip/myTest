//
//  ShopModel.m
//  旅游季
//
//  Created by niit on 16/1/14.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ShopModel.h"
#import "DealModel.h"

@implementation ShopModel

+ (void) getShopModelWithCity:(NSString *)cityName withIndex:(int)index result:(GetReuslt)resultArr{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/cities";
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:httpUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"9655d443a863591ef017472bd6094f68" forHTTPHeaderField: @"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary * result =(NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ;
       
        NSNumber *city_id = [ShopModel searchCityIdWithDict:result byCityName:cityName];
        [[NSUserDefaults standardUserDefaults]setObject:city_id forKey:City_ID];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [ShopModel requestBaiDuMomiInfoByCityID:city_id andSort:@0 page:[NSNumber numberWithInt:index] result:resultArr];
        
    }];
    [task resume];
    
}

+ (NSNumber *)searchCityIdWithDict:(NSDictionary *)cityDict byCityName:(NSString *)cityName{
    NSNumber *tempId;
    for (NSDictionary *detialDic in cityDict[@"cities"]) {
        if ([detialDic[@"city_name"] isEqualToString:cityName]) {
            tempId = detialDic[@"city_id"];
        }
    }
    return tempId;
}

+ (void)requestBaiDuMomiInfoByCityID:(NSNumber *)city_id andSort:(NSNumber *)sort page:(NSNumber *)page result:(GetReuslt)resultArr{
    
    float longitude = [[NSUserDefaults standardUserDefaults] floatForKey:CurrentCoordinate_log];
    float latitude = [[NSUserDefaults standardUserDefaults] floatForKey:CurrentCoordinate_lat];
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://apis.baidu.com/baidunuomi/openapi/searchshops?city_id=%@&location=%@,%@&sort=%@&page=%@",city_id,[NSString stringWithFormat:@"%.4f",longitude],[NSString stringWithFormat:@"%.4f",latitude],sort,page];
    NSURL *url = [NSURL URLWithString: requestUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 30];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"9655d443a863591ef017472bd6094f68" forHTTPHeaderField: @"apikey"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           NSDictionary *searchResultDict = ( NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        if (error||[searchResultDict[@"errno"] intValue]!=0) {
            NSLog(@"美食请求失败 error = %@ errno = %@",error,searchResultDict[@"errno"]);
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"loadFoodInfoErro" object:nil];
            }];
        }else{
            NSArray *shopArr =searchResultDict[@"data"][@"shops"];
            NSMutableArray *shopModelArrM = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in shopArr) {
                ShopModel *shopModel = [[ShopModel alloc]initWithDict:dict];
                [shopModelArrM addObject:shopModel];
            }
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                resultArr([shopModelArrM copy]);
            }];

        }
        
    }];
    [task resume];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        _dealsModelArr = [DealModel getDealModelArrWithArr:dict[@"deals"]];
    }
    return self;
}

- (void)reloadImageData:(GetImage)imageData;{
    
    if (_dealsModelArr.count!=0) {
        DealModel *tempModel = _dealsModelArr[0];
        NSURL *imageUrl = [NSURL URLWithString:tempModel.image];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_queue_t t = dispatch_get_main_queue();
            
            dispatch_async(t, ^{
                _titleImageData = data;
                imageData(data);
            });
      }];
        [task resume];
        
        
    }
}

@end
