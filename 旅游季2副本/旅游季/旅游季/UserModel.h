//
//  UserModel.h
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
typedef void (^Result) (BOOL enterEnable);
typedef void (^CompleteRequestImage) (id result);
@interface UserModel : NSObject

@property (strong, nonatomic) BmobObject *user_b;
@property (strong, nonatomic) NSNumber *objecId;
@property (copy, nonatomic) NSString *user_account;
@property (copy, nonatomic) NSString *user_password;
@property (copy, nonatomic) NSString *user_name;
@property (copy, nonatomic) NSString *user_city;

@property (copy,readonly, nonatomic) NSNumber *dcontent_number;
@property (copy,readonly, nonatomic) NSNumber *attention_number;
@property (copy,readonly, nonatomic) NSNumber *critique_number;
@property (copy,readonly, nonatomic) NSNumber *traver_age;

@property (copy, nonatomic) NSString *headerImageUrl;
@property (strong, nonatomic) NSData *headerImageData;
@property (strong, nonatomic) CompleteRequestImage requestImageResult;

+ (void)isNameAndPassword:(NSString *)name andPassword:(NSString *)password andResult:(Result)result;

- (instancetype)initWithBmob:(BmobObject *)b;

+(instancetype)sharedUserModel;
+(void)reloadUserAndresult:(Result)result;

@end
