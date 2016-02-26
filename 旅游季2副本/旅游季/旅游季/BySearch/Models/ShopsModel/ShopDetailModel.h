//
//  ShopDetailModel.h
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ FetchSopDetail)(id shopDetail);

@interface ShopDetailModel : NSObject

@property (copy, nonatomic) NSNumber *shop_id;//商户id
@property (copy,nonatomic) NSNumber *city_id;//城市id
@property (copy, nonatomic) NSString *shop_name;//商户名称
@property (copy, nonatomic) NSString *shop_url;//商户PC的url
@property (copy, nonatomic) NSString *shop_murl;//商户移动端url
@property (copy, nonatomic) NSString *address;//商户地址
@property (copy,nonatomic) NSNumber *district_id;//行政区id
@property (copy,nonatomic) NSNumber *bizarea_id;//商圈id
@property (copy, nonatomic) NSString *phone;//商户电话
@property (copy, nonatomic) NSString *open_time;//营业时间
@property (copy,nonatomic) NSNumber *baidu_longitude;//百度经度
@property (copy,nonatomic) NSNumber *baidu_latitude;//百度纬度
@property (copy,nonatomic) NSNumber *longitude;//经度
@property (copy,nonatomic) NSNumber *latitude;//纬度
@property (copy, nonatomic) NSString *traffic_info;//交通信息
@property (copy,nonatomic) NSNumber *update_time;//更新时间，合作方可根据该字段选择是否更新
@property (strong, nonatomic) NSData *titleImageData;

+(void)fetchShopDetailInfoWithId:(NSNumber *)shopId  andresult:(FetchSopDetail)shopDetail;


@end
