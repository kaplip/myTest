//
//  PathDetailModel.m
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "PathDetailModel.h"
#import "UserModel.h"

@implementation PathDetailModel

-(instancetype)initWithBmob:(BmobObject *)b{
    
    if (self= [super init]) {
        _name = [b objectForKey:@"placeName"];
        _Description = [b objectForKey:@"place_des"];
        _cityname = [b objectForKey:@"city_Name"];
        _abstract = [b objectForKey:@"abstract"];
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)fetchPathDetail{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.detail]];
    [request addValue:@"9655d443a863591ef017472bd6094f68" forHTTPHeaderField:@"apikey"];
    request.HTTPMethod = @"GET";
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"旅游景点pathDetail获取失败:error = %@",error);
        }else{
            NSDictionary *resultDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self setValuesForKeysWithDictionary:resultDict[@"result"]];
       }
    }];
    [task resume];
}

- (void)fetchImageDataCompelete:(CompeleteFetch)result{
    
    NSString *httpUrl = @"http://apis.baidu.com/image_search/search/search";
    NSString *httpArg = [NSString stringWithFormat:@"word=%@%@&pn=0&rn=1&ie=utf-8",[self hexStringFromString: _cityname],[self hexStringFromString:_name]];
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
            _imageData = imageData;
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                result(imageData);
            }];
            
        }
    }];
    [datatask resume];
    
    
}

- (NSString *)hexStringFromString:(NSString *)string{
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

+ (void)loadMyFavPathDetailWtihDate:(NSDate *)currentDate result:(CompeleteFetch)result{
    
    UserModel *currentUser = [UserModel sharedUserModel];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"fa_place"];
    [bquery includeKey:@"user"];
    bquery.limit = 10;
    [bquery whereKey:@"createdAt" lessThanOrEqualTo:currentDate];
    [bquery whereKey:@"user" equalTo:currentUser.user_b];
    [bquery orderByDescending:@"createdAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSMutableArray *arr  = [[NSMutableArray alloc]init];
            for (BmobObject *b in array) {
                PathDetailModel *pathModel = [[PathDetailModel alloc]initWithBmob:b];
                [arr addObject:pathModel];
            }
            result([arr copy]);
        }
    }];
}


@end
