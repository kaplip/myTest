//
//  UserModel.m
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "UserModel.h"
#import <BmobSDK/Bmob.h>

static UserModel *stanceUser = nil;
static BmobObject *tempUserBmob;
@implementation UserModel
+(instancetype)sharedUserModel{
    
    if (stanceUser==nil) {
        stanceUser = [[UserModel alloc]initWithBmob:tempUserBmob];
    }
    return stanceUser;
}

+ (void)isNameAndPassword:(NSString *)name andPassword:(NSString *)password andResult:(Result)result {
    
  __block  BOOL enterEnable=NO;
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    
    [bquery whereKey:UserAccount equalTo:name];
    [bquery whereKey:UserPassword equalTo:password];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {

        for (BmobObject *b in array) {
            if (b!=nil) {
                
                tempUserBmob = b;
                [[NSUserDefaults standardUserDefaults]setObject:b.objectId forKey:UserID];
                [[NSUserDefaults standardUserDefaults]setObject:name forKey:UserAccount];
                [[NSUserDefaults standardUserDefaults]synchronize];
                enterEnable = YES;
            }
        }
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            result(enterEnable);
        }];
    }];
}


- (instancetype)initWithBmob:(BmobObject *)b{
    
    if (self = [super init]) {
        _user_account = [b objectForKey:@"user_account"];
        _user_name = [b objectForKey:@"user_name"];
        _user_password = [b objectForKey:@"user_password"];
        _dcontent_number = [b objectForKey:@"dcontent_number"];
        _attention_number = [b objectForKey:@"attention_number"];
        _critique_number = [b objectForKey:@"critique_number"];
        _objecId = [b objectForKey:@"objectId"];
        _user_city = [b objectForKey:@"user_city"];
        _headerImageUrl = [b objectForKey:@"headerUrl"];
      _user_b = b;
    }
    return self;
}

+(void)reloadUserAndresult:(Result)result{
    stanceUser = nil;
    NSString *currentUser = [[NSUserDefaults standardUserDefaults]objectForKey:UserID];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery whereKey:@"objectId" equalTo:currentUser];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"用户信息更新失败");
        }else{
            
            for (BmobObject *b in array) {
                tempUserBmob = b;
            }
              result(YES);
        }
    }];
}

@end
