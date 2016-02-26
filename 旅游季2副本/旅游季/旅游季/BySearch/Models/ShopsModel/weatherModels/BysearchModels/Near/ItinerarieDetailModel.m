//
//  ItinerarieDetailModel.m
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ItinerarieDetailModel.h"
#import "PathDetailModel.h"
@implementation ItinerarieDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in _path) {
            PathDetailModel *pathDetailModel = [[PathDetailModel alloc]initWithDict:dict];
            [pathDetailModel fetchPathDetail];
            [arrM addObject:pathDetailModel];
        }
        _pathDetailModel = [arrM copy];
        if (_accommodation) {
             _accommodation = [NSString stringWithFormat:@"        %@",_accommodation];
        }
        if (_Description>0) {
           _Description = [NSString stringWithFormat:@"        %@",_Description];
        }
        if (_dinning.length>0) {
           _dinning = [NSString stringWithFormat:@"        美食推荐:%@",_dinning];
        }
    }
    return self;
}


- (void)setCityname:(NSString *)cityname{
    _cityname = cityname;
    for (PathDetailModel *pathDetailM in _pathDetailModel) {
        pathDetailM.cityname = _cityname;
    }
}

@end
