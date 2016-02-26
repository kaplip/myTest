//
//  BySearchModel.h
//  旅游季
//
//  Created by niit on 16/2/20.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
typedef void (^ fetchSearchInfo)(id result);

@interface BySearchModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *imageUrl;

+ (void)loadSearchInfoWithDate: (NSDate *)currentDate andResult:(fetchSearchInfo)result;

@end
