//
//  Bmob+BmobDataModelTool.h
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <BmobSDK/Bmob.h>
@class UserModel;
@class ShareModel;
@class CritiqueModel;
@class PathDetailModel;

typedef void (^ AdjustExist)(BOOL result);
typedef void  (^InseterAction)(id result);

@interface Bmob (BmobDataModelTool)

+ (void)inseterUserInfo:(UserModel *)userModel;
+ (void)inseterShareInfo:(ShareModel *)shareModel andInsterAction:(InseterAction)result;
+ (void)saveHeaderWithUser:(UserModel *)userModel andResult:(InseterAction)result;
+ (void)inseterCritiqueModel:(CritiqueModel *)critiqueModel;

+(void)modifeMessageInfoWithNotice:(ShareModel *)shareModel andInsterAction:(InseterAction)adjustresult;
+ (void)modifeChatDate:(BmobObject *)object withKey:(NSString *)key;

+ (void)savePathDetail:(PathDetailModel *)pathDetail;
+ (void)addjustPathAleadySave:(PathDetailModel *)path  andResult:(AdjustExist )result;
@end
