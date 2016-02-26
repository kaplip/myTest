//
//  ItinerarieModel.m
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ItinerarieModel.h"
#import "ItinerarieDetailModel.h"
@implementation ItinerarieModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (void)loadItinerarieDetails:(compeletFetch)compelet{
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in _itineraries) {
        
        ItinerarieDetailModel *detailModel = [[ItinerarieDetailModel alloc]initWithDict:dict];
        detailModel.cityname = _cityname;
        [arrM addObject:detailModel];
    }
    _itinerarieDetails = [arrM copy];
    compelet();
}


@end
