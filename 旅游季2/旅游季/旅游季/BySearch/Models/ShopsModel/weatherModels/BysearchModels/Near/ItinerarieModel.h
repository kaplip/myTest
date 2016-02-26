//
//  ItinerarieModel.h
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ compeletFetch)();
@interface ItinerarieModel : NSObject

@property (copy, nonatomic) NSString *cityname;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *Description;

@property (strong, nonatomic) NSArray *itineraries;
@property (strong, nonatomic) NSArray *itinerarieDetails;

@property (assign, nonatomic) BOOL selected;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (void)loadItinerarieDetails:(compeletFetch)compelet;

@end
