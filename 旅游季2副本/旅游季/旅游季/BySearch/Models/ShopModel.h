//
//  ShopModel.h
//  旅游季
//
//  Created by niit on 16/1/14.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class DealModel;

typedef void (^GetReuslt) (id shopResultArr);
typedef void (^ GetImage)(id imageData);

@interface ShopModel : NSObject

@property (strong, nonatomic) NSData *titleImageData;

@property (copy, nonatomic)  NSNumber *deal_num;
@property (strong, nonatomic) NSDictionary *  deals;
@property (strong, nonatomic) NSArray *dealsModelArr;
@property (copy, nonatomic) NSString *distance;

@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;

@property (copy, nonatomic) NSNumber *shop_id;
@property (copy, nonatomic) NSString *shop_murl;
@property (copy, nonatomic) NSString *shop_name;
@property (copy, nonatomic) NSString *shop_url;

+ (void) getShopModelWithCity:(NSString *)cityName withIndex:(int)index result:(GetReuslt)resultArr;

+ (void)requestBaiDuMomiInfoByCityID:(NSNumber *)city_id andSort:(NSNumber *)sort page:(NSNumber *)page result:(GetReuslt)resultArr;

//shop详情

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *open_time;


- (void)reloadImageData:(GetImage)imageData;

@end
