//
//  BySearchHeaderView.h
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//


#import <UIKit/UIKit.h>
@class CustomCell;
@protocol ChoiceSortDelegate <NSObject>

- (void)didChoiceSort:(CustomCell *)sort;

@end

@interface BySearchHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) id <ChoiceSortDelegate> sortDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)initUI;

@end
