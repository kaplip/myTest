//
//  NearDetailTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItDetailFrameModel;

@interface NearDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) ItDetailFrameModel *itDetailFrameModel;
@property (assign, nonatomic) int index;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;



@end
