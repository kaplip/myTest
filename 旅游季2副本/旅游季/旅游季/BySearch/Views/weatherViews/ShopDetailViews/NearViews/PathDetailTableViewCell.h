//
//  PathDetailTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/21.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PathDetailModel;
@interface PathDetailTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (strong, nonatomic) PathDetailModel *pathDetail;

@end
