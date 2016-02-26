//
//  CritiqueModel.m
//  旅游季
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "CritiqueModel.h"
#import <BmobSDK/Bmob.h>

@implementation CritiqueModel

+ (void)loadCritiqueWithShareModel:(ShareModel *)shareModel andResult:(FetchCritique)result{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"critique"];
    [bquery whereKey:@"shareMessage" equalTo:shareModel.message_b];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else{
            NSMutableArray *arr  = [[NSMutableArray alloc]init];
            for (BmobObject *b in array) {
                CritiqueModel *model = [[CritiqueModel alloc]init];
                model.objectId = [b objectForKey:@"objectId"];
                model.content =[NSString stringWithFormat:@"    %@",[b objectForKey:@"content"]] ;
                model.creatTime = [b objectForKey:@"createdAt"];
                [arr addObject:model];
            }
            if (arr.count==0) {
                result(nil);
            }else{
                result(arr);
            }
        }
    }];
}

- (void)findUserInfoWithObjectId:(NSString *)objectId andResult:(FetchCritique)result{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"critique"];
    [bquery includeKey:@"cri_user"];
    [bquery getObjectInBackgroundWithId:objectId block:^(BmobObject *object, NSError *error) {
        BmobObject *userObj = [object objectForKey:@"cri_user"];
        UserModel *user = [[UserModel alloc]initWithBmob:userObj];
        self.userModel  = user;
        
        dispatch_queue_t t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(t, ^{
            NSData *headerImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.headerImageUrl]];
            self.userModel.headerImageData = headerImageData;
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                result(user);
            }];
            
        });
    }];
}

@end
