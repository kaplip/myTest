//
//  ShareModel.h
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
#import "ImageModel.h"
@class UserModel;

typedef void (^ ResultArr)(id resultArray);
typedef void (^ RequstImages)(NSArray *resultArr);
typedef void (^ RequstAuthor)(UserModel *resultAuthor);

@interface ShareModel : NSObject

@property (strong, nonatomic) BmobObject *message_b;
@property (copy, readonly, nonatomic) NSString *objectKey;
@property (copy,readonly ,nonatomic) NSNumber *list_id;
@property (copy,readonly, nonatomic) NSString *list_content;
@property (strong, nonatomic)         NSString *createdAt;

@property (copy,readonly, nonatomic) NSString *post_time;
@property (copy,readonly, nonatomic) NSString *post_position;
@property (copy,readonly, nonatomic) NSNumber *praise_number;
@property (copy,readonly, nonatomic) NSNumber *critique_number;

@property (strong, nonatomic)          NSNumber *imageCount;
@property (strong, nonatomic)          NSArray *imageArr;

@property (strong, readonly, nonatomic) UserModel *author;

+ (void)getShareMessageArrWithDate:(NSDate *)currentDate andResult:(ResultArr)result;

+ (void)getShareMessageArrWithDate:(NSDate *)currentDate andUser:(BmobObject *)user_b andResult:(ResultArr)result;

+ (void)getMyMessageArrWithDate:(NSDate *)currentDate andUser:(BmobObject *)user_b andResult:(ResultArr)result;


- (instancetype)initShareModelWithContent:(NSString *)content andImages:(NSArray <UIImage *>*)images;

//- (void)requestImage:(RequstImages)resultImages;
- (void)requestAuthor:(RequstAuthor)resultAuthor;
- (instancetype)initWithBmob:(BmobObject *)b;
@end
