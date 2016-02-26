//
//  FilterModel.h
//  旅游季
//
//  Created by niit on 16/1/23.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterModel : NSObject
- (void)setFilterWithTag:(NSInteger)tag;
@property (strong, nonatomic) CIFilter *filter;
@property (copy, readonly ,nonatomic) NSString *filterName;
@property (copy, readonly, nonatomic) NSString *filterAttributeName;
@end
