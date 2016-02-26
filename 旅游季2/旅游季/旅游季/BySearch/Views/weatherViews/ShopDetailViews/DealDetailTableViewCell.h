//
//  DealDetailTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DealFrameModel;
@interface DealDetailTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (strong, nonatomic) DealFrameModel *dealFrameModel;

@end
