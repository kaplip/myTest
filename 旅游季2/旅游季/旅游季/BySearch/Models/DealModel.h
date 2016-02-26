//
//  DealModel.h
//  旅游季
//
//  Created by niit on 16/1/14.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ FetchImage)(id ImageData);
@interface DealModel : NSObject

@property (copy, nonatomic) NSNumber *comment_num;
@property (copy, nonatomic) NSNumber *current_price;//团购价格
@property (copy, nonatomic) NSNumber *deal_id;

@property (copy, nonatomic) NSString *deal_murl;
@property (copy, nonatomic) NSString *deal_url;
@property (copy, nonatomic) NSString *Description;
@property (copy, nonatomic) NSString *image;

@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *min_title;

@property (copy, nonatomic) NSNumber *promotion_price;//单品售价
@property (copy, nonatomic) NSNumber *sale_num;//销售数量
@property (copy, nonatomic) NSString *sale_numStr;

@property (copy, nonatomic) NSString *score;//用户评分
@property (copy, nonatomic) NSString *tiny_image;
@property (copy, nonatomic) NSString *title;

+(NSArray *)getDealModelArrWithArr:(NSArray *)arr;

-(void)fecthImage:(FetchImage)result;

@end
