//
//  CityModel.h
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^ CompeleteFetch)(id result);

@interface CityModel : NSObject

@property (copy,nonatomic) NSNumber *cityid;
@property (copy, nonatomic) NSString *cityname;
@property (strong, nonatomic) NSDictionary *location;

@property (copy ,nonatomic) NSString *star;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *abstract;
@property (copy, nonatomic) NSString *Description;

@property (strong, nonatomic) NSArray *itinerariModels;
@property (strong, nonatomic) NSArray *itineraries;

@property (strong, nonatomic) NSData *imageData;

+ (void)fetchDataWithCityName:(NSString *)cityName complete:(CompeleteFetch)result;
- (void)fetchImageWithCityName:(CityModel *)city fetchOP:(CompeleteFetch)result;
@end
