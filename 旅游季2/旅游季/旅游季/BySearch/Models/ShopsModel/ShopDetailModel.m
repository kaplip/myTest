//
//  ShopDetailModel.m
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ShopDetailModel.h"

@implementation ShopDetailModel
+(void)fetchShopDetailInfoWithId:(NSNumber *)shopId  andresult:(FetchSopDetail)shopDetail{
    
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/shopinfo";
    NSString *urlStr = [NSString stringWithFormat:@"%@?shop_id=%@",httpUrl,shopId];
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    request.HTTPMethod = @"GET";
    [request addValue:@"9655d443a863591ef017472bd6094f68" forHTTPHeaderField:@"apikey"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"erro = %@",error);
        }else{
            
            NSDictionary *resultDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *shopDict = resultDict[@"shop"];
            ShopDetailModel *shopDetailModel = [[ShopDetailModel alloc]initWtihDict:shopDict];
            dispatch_queue_t t = dispatch_get_main_queue();
            dispatch_async(t, ^{
                shopDetail(shopDetailModel);
            });
        }
    }];
    [dataTask resume];
}

- (instancetype)initWtihDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _phone = [NSString stringWithFormat:@"电话：%@",_phone];
        _address  =[NSString stringWithFormat:@"地址：%@",_address];
    }
    return self;
}

@end
