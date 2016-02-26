//
//  MyCenterTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCenterTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@property (assign, nonatomic) NSInteger index;
@end
