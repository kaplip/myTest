//
//  Bmob+BmobDataModelTool.m
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "Bmob+BmobDataModelTool.h"
#import "UserModel.h"
#import "ShareModel.h"
#import "CritiqueModel.h"
#import "PathDetailModel.h"


@implementation Bmob (BmobDataModelTool)
+ (void)inseterUserInfo:(UserModel *)userModel{
    
    BmobObject *userChat = [BmobObject objectWithClassName:@"UserInfo"];
    
    [userChat setObject:userModel.user_account forKey:@"user_account"];
    [userChat setObject:userModel.user_password forKey:@"user_password"];
    [userChat setObject:userModel.user_name forKey:@"user_name"];
    [userChat setObject:@0 forKey:@"dcontent_number"];
    [userChat setObject:@0 forKey:@"critique_number"];
    [userChat setObject:@0 forKey:@"attention_number"];
    [userChat setObject:@0 forKey:@"traver_age"];
   
    [userChat saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (!isSuccessful) {
            NSLog(@"注册失败， error = %@",error);
        }
    }];
}


+ (void)inseterShareInfo:(ShareModel *)shareModel andInsterAction:(InseterAction)result {
    
    BmobObject *shareChat = [BmobObject objectWithClassName:@"ShareMessage"];
    BmobObject *imageObj = [BmobObject objectWithClassName:@"ImageAuthor"];
    
    NSString *objectKey = [[NSUserDefaults standardUserDefaults]objectForKey:UserID];
    BmobObject *user = [BmobObject objectWithoutDatatWithClassName:@"UserInfo" objectId:objectKey];
    NSNumber *imagesCount;
    
    if (shareModel.imageArr&&shareModel.imageArr.count!=0) {
      imagesCount  = [NSNumber numberWithInteger:shareModel.imageArr.count];
    }else{
        imagesCount = @0;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *author_id = [[NSUserDefaults standardUserDefaults] objectForKey:UserID];

    for (int i = 0;i<shareModel.imageArr.count;i++) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@%i.jpg",dateStr,author_id,i];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:fileName];
        UIImage *tempImage = shareModel.imageArr[i];
        CGFloat image_W = tempImage.size.width;
        CGFloat image_H = tempImage.size.height;
        NSData *imageData =UIImageJPEGRepresentation(shareModel.imageArr[i], 0.01);
        
        [imageData writeToFile:path atomically:YES];
        
            BmobFile *imageFile = [[BmobFile alloc]initWithFilePath:path];
            [imageFile saveInBackgroundByDataSharding:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                   
                    //写入动态
                    [shareChat setObject:user forKey:@"author"];
                    [shareChat setObject:shareModel.list_content forKey:@"list_content"];
                    [shareChat setObject:shareModel.post_time forKey:@"post_time"];
                    [shareChat setObject:shareModel.post_position forKey:@"post_position"];
                    [shareChat setObject:imagesCount forKey:@"ImageCount"];
                    [shareChat setObject:@0 forKey:@"praise_number"];
                    [shareChat setObject:@0 forKey:@"critique_number"];
                    
                    [shareChat saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"动态发送成功");
                            
                            //写入图片
                            [imageObj setObject:imageFile.url forKey:@"url"];
                            [imageObj setObject:[NSNumber numberWithFloat:image_W] forKey:@"image_W"];
                            [imageObj setObject:[NSNumber numberWithFloat:image_H] forKey:@"image_H"];
                            [imageObj setObject:shareChat forKey:@"Message"];
                            
                            [imageObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {
                                    NSLog(@"图片保存成功");
                                    result(@1);
                                    [Bmob modifeChatDate:user withKey:@"dcontent_number"];
                                }else {
                                    NSLog(@"图片保存错误 error= %@",error);
                                    result(@0);
                                }
                            }];
                        }
                    }];
                  }
            } progressBlock:^(float progress) {
                NSLog(@"%@上传%.2f",imageFile.name,progress);
            }];
    }
}



+ (void)saveHeaderWithUser:(UserModel *)userModel andResult:(InseterAction)result{
    NSString *fileName =[NSString stringWithFormat:@"%@123459.jpg", userModel.user_name];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    };
        [userModel.headerImageData writeToFile:path atomically:YES];
  
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"UserInfo"];
    [bquery getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@", userModel.objecId ] block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobFile *imageFile = [[BmobFile alloc]initWithFilePath:path];
                [imageFile saveInBackgroundByDataSharding:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        NSLog(@"用户信息修改失败 error = %@",error);
                    }
                    if (isSuccessful) {
                        NSLog(@"%@",[object objectForKey:@"user_name"]);
                        [object setObject:imageFile.url forKey:@"headerUrl"];
                        [object setObject:userModel.user_name forKey:@"user_name"];
                        [object setObject:userModel.user_password forKey:@"user_password"];
                        [object setObject:userModel.user_city forKey:@"user_city"];
                        [object updateInBackground];
                        result(nil);
                    }
                } progressBlock:^(float progress) {
                    NSLog(@"%@上传%.2f",imageFile.name,progress);
                }];
                //异步更新数据
            }
        }else{
            NSLog(@"跟新用户数据错误");//进行错误处理
        }
    }];
}

+ (void)inseterCritiqueModel:(CritiqueModel *)critiqueModel{
    
    BmobObject *critiqueModel_bmob = [BmobObject objectWithClassName:@"critique"];
    
    [critiqueModel_bmob setObject:critiqueModel.content forKey:@"content"];
    [critiqueModel_bmob setObject:critiqueModel.userModel.user_b forKey:@"cri_user"];
    [critiqueModel_bmob setObject:critiqueModel.shareModel.message_b forKey:@"shareMessage"];
    
    [critiqueModel_bmob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (!isSuccessful) {
            NSLog(@"评论失败， error = %@",error);
        }else{
            
            [Bmob modifeChatDate:critiqueModel.userModel.user_b withKey:@"critique_number"];
        }
    }];
}

+(void)modifeMessageInfoWithNotice:(ShareModel *)shareModel andInsterAction:(InseterAction)adjustresult{
    
    UserModel *currentUser = [UserModel sharedUserModel];
    BmobObject *collectionMessageChat = [BmobObject objectWithClassName:@"CollectionMessage"];
   
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"ShareMessage"];
    [bquery getObjectInBackgroundWithId:shareModel.objectKey block:^(BmobObject *object, NSError *error) {
        if (error) {
            NSLog(@"动态查找失败 error = %@",error);
        }else{
            
             [Bmob adjustCollectExist:object andUserB:currentUser.user_b andReuslt:^(BOOL result) {
                 if (!result) {
                     adjustresult(@1);
                     [collectionMessageChat setObject:object forKey:@"ShareMessage"];
                     [collectionMessageChat setObject:currentUser.user_b forKey:@"user"];
                     [collectionMessageChat saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                         if (error) {
                             NSLog(@"收藏动态失败error = %@",error);
                         }else{
                             
                             [Bmob modifeChatDate:object withKey:@"praise_number"];
                             [Bmob modifeChatDate:currentUser.user_b withKey:@"attention_number"];
                         }
                     }];
                 }else{
                     adjustresult(@0);
                     NSLog(@"该动态你已经收藏");
                 }
             }];

        }
    }];
}



+ (void)modifeChatDate:(BmobObject *)object withKey:(NSString *)key{
    int i = [[object objectForKey: key]intValue];
    i++;
  [object setObject:[NSNumber numberWithInt:i] forKey:key];
  [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
      if (error) {
          NSLog(@"数据修改失败error%@",error);
      }else{
          NSLog(@"数据修改成功");

      }
  }];
}

+ (void)adjustCollectExist:(BmobObject *)message andUserB:(BmobObject *)user andReuslt:(AdjustExist)result{
    
     BmobQuery   *bquery = [BmobQuery queryWithClassName:@"CollectionMessage"];
    [bquery whereKey:@"ShareMessage" equalTo:message];
    [bquery whereKey:@"user" equalTo:user];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            NSLog(@"判断动态是否已经收藏错误error = %@",error);
        }else {
            if (array.count==0) {
                result(NO);
            }else{
                result(YES);
            }
        }
    }];
    
}


+ (void)savePathDetail:(PathDetailModel *)pathDetail{
     UserModel *user = [UserModel sharedUserModel];
    [Bmob addjustPathAleadySave:pathDetail andResult:^(BOOL result) {
        if (!result) {
            BmobObject *b = [BmobObject objectWithClassName:@"fa_place"];
            [b setObject:pathDetail.name forKey:@"placeName"];
            [b setObject:pathDetail.Description forKey:@"place_des"];
            [b setObject:pathDetail.cityname forKey:@"city_Name"];
            [b setObject:pathDetail.abstract forKey:@"abstract"];
            [b setObject:user.user_b forKey:@"user"];
            [b saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    NSLog(@"地标收藏失败");
                }else {
                    NSLog(@"地标收藏成功");
                }
            }];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AleadySavePalce" object:nil];
            NSLog(@"该地点你已经收藏");
        }
    }];
   
}


+ (void)addjustPathAleadySave:(PathDetailModel *)path  andResult:(AdjustExist )result{
    UserModel *user = [UserModel sharedUserModel];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"fa_place"];
    [bquery includeKey:@"user"];
    [bquery whereKey:@"placeName" equalTo:path.name];
    [bquery whereKey:@"user" equalTo:user.user_b];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            NSLog(@"判断动态是否已经收藏错误error = %@",error);
        }else {
            if (array.count==0) {
                result(NO);
            }else{
                result(YES);
            }
        }
    }];
}

@end
