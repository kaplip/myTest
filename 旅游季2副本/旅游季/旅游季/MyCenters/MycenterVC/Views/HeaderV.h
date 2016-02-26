//
//  HeaderV.h
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@protocol HeaderActionDelegate <NSObject>

- (void)didSelectedHeader;

@end
@interface HeaderV : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UserModel *user;
@property (weak, nonatomic) id <HeaderActionDelegate> delegate;
@property (strong, nonatomic) NSData *headerImageData;

@end
