//
//  SearchTabelCellTableViewCell.h
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BySearchModel.h"

@interface SearchTabelCellTableViewCell : UITableViewCell

@property (strong, nonatomic) BySearchModel *searchModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
