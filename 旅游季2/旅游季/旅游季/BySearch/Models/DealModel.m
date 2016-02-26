//
//  DealModel.m
//  旅游季
//
//  Created by niit on 16/1/14.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "DealModel.h"

@implementation DealModel

+(NSArray *)getDealModelArrWithArr:(NSArray *)arr{
    NSMutableArray *dealArrM = [[NSMutableArray alloc]initWithCapacity:arr.count];
    for (NSDictionary *dict in arr) {
        
        DealModel *dealModel = [[DealModel alloc]initDealModelArrWithDict:dict];
        
        [dealArrM addObject:dealModel];
    }
    
    return [dealArrM copy];
}


- (instancetype)initDealModelArrWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _sale_numStr = [NSString stringWithFormat:@"销售数量：%@",_sale_num];
        _score = [NSString stringWithFormat:@"用户评分：%@",_score];
    }
    return self;
}

-(void)fecthImage:(FetchImage)result{
    
    NSURL *url = [NSURL URLWithString:_image];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    NSURLSession *session = [NSURLSession sharedSession];
   NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       dispatch_queue_t t = dispatch_get_main_queue();
       dispatch_async(t, ^{
           
           result(data);
       });
       
   }];
    
    [task resume];
    
}

@end
