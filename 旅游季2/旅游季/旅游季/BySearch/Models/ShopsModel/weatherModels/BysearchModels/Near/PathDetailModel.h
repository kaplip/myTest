//
//  PathDetailModel.h
//  旅游季
//
//  Created by niit on 16/1/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bmob+BmobDataModelTool.h"

typedef void (^FetchPath)(id result);
typedef  void (^ CompeleteFetch)(id result);
@interface PathDetailModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSDictionary *location;
@property (copy, nonatomic) NSString *star;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *abstract;
@property (copy, nonatomic) NSString *Description;
@property (strong, nonatomic) NSDictionary *ticket_info;

@property (strong, nonatomic) NSData *imageData;
@property (copy, nonatomic) NSString *cityname;

+ (void)loadMyFavPathDetailWtihDate:(NSDate *)currentDate result:(CompeleteFetch)result;

-(instancetype)initWithBmob:(BmobObject *)b;
- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)fetchPathDetail;
- (void)fetchImageDataCompelete:(CompeleteFetch)result;
@end
