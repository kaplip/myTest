//
//  EditUserInfoVC.h
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//
@protocol RefreshUserInfoDelegate <NSObject>

- (void)refreshUserInfoAction;

@end


#import <UIKit/UIKit.h>
@class UserModel;
@interface EditUserInfoVC : UITableViewController


@property (weak, nonatomic) id <RefreshUserInfoDelegate> delegate;
@property (strong, nonatomic) UserModel *user;

@end
