//
//  BySearchModel.m
//  旅游季
//
//  Created by niit on 16/2/20.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "BySearchModel.h"

@implementation BySearchModel
+ (void)loadSearchInfoWithDate: (NSDate *)currentDate andResult:(fetchSearchInfo)result{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"SearchContent"];
    bquery.limit = 10;
    [bquery whereKey:@"createdAt" lessThanOrEqualTo:currentDate];
    [bquery orderByDescending:@"createdAt"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"搜索推荐信息加载失败 error = %@",error);
        }else{
            NSMutableArray *arrM = [[NSMutableArray alloc]init];
            for (BmobObject *b in array) {
                BySearchModel *searchModel = [[BySearchModel alloc]initWithBmobObject:b];
                [arrM addObject:searchModel];
            }
            result( [arrM copy] );
        }
    }];
}

- (instancetype)initWithBmobObject:(BmobObject *)b{
    
    if (self = [super init]) {
        _imageUrl = [b objectForKey:@"imageUrl"];
        _content = [b objectForKey:@"content"];
        _title = [b objectForKey:@"title"];
    }
    return self;
}

@end
