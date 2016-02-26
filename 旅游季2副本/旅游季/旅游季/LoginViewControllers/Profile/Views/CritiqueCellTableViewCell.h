//
//  CritiqueCellTableViewCell.h
//  旅游季
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CritiqueCellFrame;
@interface CritiqueCellTableViewCell : UITableViewCell

@property (strong, nonatomic) CritiqueCellFrame *frameModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
