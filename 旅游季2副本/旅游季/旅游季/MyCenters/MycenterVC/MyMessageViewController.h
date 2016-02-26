//
//  ProfileViewController.h
//  旅游季
//
//  Created by niit on 15/12/26.
//  Copyright © 2015年 niit. All rights reserved.
//
typedef enum RefreshType {
    refreshTypeNew,
    refreshTypeOld
    
}RefreshType;

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface MyMessageViewController : UIViewController

@property (strong, nonatomic) UserModel *currentUser;
@property (strong,nonatomic) NSString *messageDetailTitle;
@property (assign,nonatomic ) int searchIndex;

@end
