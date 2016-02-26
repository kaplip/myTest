//
//  CritiqueModel.h
//  旅游季
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"
#import "UserModel.h"

typedef void (^ FetchCritique)(id result);
@interface CritiqueModel : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) ShareModel *shareModel;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) NSString *creatTime;


+ (void)loadCritiqueWithShareModel:(ShareModel *)shareModel andResult:(FetchCritique)result;
- (void)findUserInfoWithObjectId:(NSString *)objectId andResult:(FetchCritique)result;
@end
