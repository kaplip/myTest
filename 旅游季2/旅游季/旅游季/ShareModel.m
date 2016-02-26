//
//  ShareModel.m
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ShareModel.h"
#import "UserModel.h"

@interface ShareModel()

@property (strong, nonatomic) BmobObject *tempB;

@end


@implementation ShareModel

- (instancetype)initShareModelWithContent:(NSString *)content andImages:(NSArray <UIImage *>*)images{
    
    if(self = [super init]){

        NSString *user_location = [[NSUserDefaults standardUserDefaults]objectForKey:UserLocation];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *date =[NSDate date];
        NSString *dateStr = [formatter stringFromDate:date];
        
        _list_content = content;
        _post_time = dateStr;
        _post_position = user_location;
        _imageArr = images;
    }
    return self;
}

+ (void)getShareMessageArrWithDate:(NSDate *)currentDate andUser:(BmobObject *)user_b  andResult:(ResultArr)result{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"ShareMessage"];
    bquery.limit = 10;
    [bquery whereKey:@"createdAt" lessThanOrEqualTo:currentDate];
    [bquery whereKey:@"author" equalTo:user_b];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"动态查询失败");
        }else {
            
            NSMutableArray *arr  = [[NSMutableArray alloc]init];
            for (BmobObject *b in array) {
                ShareModel *model = [[ShareModel alloc]initWithBmob:b];
                [model requestImage:^(NSArray *resultArr) {
                    model.imageArr = resultArr;
                    [arr addObject:model];
                    if (arr.count==array.count) {
                        result(arr);
                    }
                }];
            }
            if (arr.count==0) {
                result(nil);
            }
        }
    }];
}


+ (void)getShareMessageArrWithDate:(NSDate *)currentDate andResult:(ResultArr)result{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"ShareMessage"];
    bquery.limit = 10;
    [bquery whereKey:@"createdAt" lessThanOrEqualTo:currentDate];
    [bquery orderByDescending:@"createdAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSMutableArray *arr  = [[NSMutableArray alloc]init];
            for (BmobObject *b in array) {
                ShareModel *model = [[ShareModel alloc]initWithBmob:b];
              
                [model requestImage:^(NSArray *resultArr) {
                   model.imageArr = resultArr;
                   [arr addObject:model];
                    if (arr.count==array.count) {
                          result(arr);
                    }
              }];
            }
            if (arr.count==0) {
                result(nil);
            }
        }
    }];
}

+ (void)getMyMessageArrWithDate:(NSDate *)currentDate andUser:(BmobObject *)user_b andResult:(ResultArr)result{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"CollectionMessage"];
    bquery.limit = 10;
    [bquery whereKey:@"createdAt" lessThanOrEqualTo:currentDate];
    [bquery orderByDescending:@"createdAt"];
    [bquery includeKey:@"user"];
    [bquery includeKey:@"ShareMessage"];
    [bquery whereKey:@"user" equalTo:user_b];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSMutableArray *arr  = [[NSMutableArray alloc]init];
            for (BmobObject *b in array) {
                BmobObject *messageObject = [b objectForKey:@"ShareMessage" ];
                ShareModel *model = [[ShareModel alloc]initWithBmob:messageObject];
                    [model requestImage:^(NSArray *resultArr) {
                        model.imageArr = resultArr;
                        [arr addObject:model];
                    result(arr);
                    }];
                
            }
            if (arr.count==0) {
                result(nil);
            }
        }
    }];
}


- (instancetype)initWithBmob:(BmobObject *)b{
    
    if (self = [super init]) {
        _tempB = b;
        _list_content =[NSString stringWithFormat:@"    %@",[b objectForKey:@"list_content"]];
        _list_id = [b objectForKey:@"list_id"];
        _post_position =[NSString stringWithFormat:@"%@",[b objectForKey:@"post_position"]];
        _post_time = [b objectForKey:@"post_time"];
        _praise_number = [b objectForKey:@"praise_number"];
        _critique_number = [b objectForKey:@"critique_number"];
        _objectKey = [b objectForKey:@"objectId"];
        _imageCount = [b objectForKey:@"ImageCount"];
        _createdAt = [b objectForKey:@"createdAt"];
        _message_b = b;
        
    }
    return self;
}

- (void)requestImage:(RequstImages)resultImages{
    [ImageModel requestImageDataWithMessageId:_objectKey result:^(id result) {
        NSArray *tempResult = (NSArray *)result;
        _imageArr = (NSArray *)result;
        resultImages(tempResult);
    }];
}

- (void)requestAuthor:(RequstAuthor)resultAuthor{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"ShareMessage"];
    [bquery includeKey:@"author"];
    [bquery getObjectInBackgroundWithId:_objectKey block:^(BmobObject *object, NSError *error) {
        UserModel *author = [[UserModel alloc]initWithBmob:
                             [object objectForKey:@"author"]];
        _author = author;
        resultAuthor(_author);
    }];
}

@end
