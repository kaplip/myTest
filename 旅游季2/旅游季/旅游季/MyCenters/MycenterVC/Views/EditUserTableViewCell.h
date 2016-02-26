//
//  EditUserTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/26.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  UserModel;
@interface EditUserTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (assign ,nonatomic) NSInteger index;
@property (copy, nonatomic) NSString *attributeTitle;
@property (strong, nonatomic) UserModel *user;


@property (strong, nonatomic) UIImage *headerImage;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) UITextField *textField;
@end
