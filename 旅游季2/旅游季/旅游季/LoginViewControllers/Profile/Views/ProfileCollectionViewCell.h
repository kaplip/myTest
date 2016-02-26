//
//  ProfileTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileViewCellFrame;

@interface ProfileCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ProfileViewCellFrame *frameModel;

- (instancetype)initWithFrame:(CGRect)frame;

@end
