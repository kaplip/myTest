//
//  ItinerarieDetailModel.h
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItinerarieDetailModel : NSObject

@property (copy, nonatomic) NSString *cityname;

@property (strong, nonatomic) NSArray *pathDetailModel;
@property (strong, nonatomic) NSArray *path;

@property (copy, nonatomic) NSString *Description;
@property (copy, nonatomic) NSString *dinning;
@property (copy, nonatomic) NSString *accommodation;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
