//
//  CustomCell.h
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomCell;
@protocol SortOnChoiceDelegate <NSObject>

- (void)sortButtonOnClick:(CustomCell *)cell;

@end

@interface CustomCell : UIView

@property (strong,nonatomic) NSString *sortTitle; 
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic) NSInteger sortTag;

@property (weak, nonatomic) id <SortOnChoiceDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame;

@end
