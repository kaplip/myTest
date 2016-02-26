//
//  FoodSearchTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/16.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopModel;

@interface FoodSearchTableViewCell : UITableViewCell

@property (strong, nonatomic) ShopModel *shopModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
