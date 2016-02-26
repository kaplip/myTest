//
//  FoodTabFootView.h
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoadMoreActionDelaegate <NSObject>

- (void)loadModreAction:(UIButton *)tempButton;

@end
@interface FoodTabFootView : UIView
@property (weak, nonatomic) IBOutlet UIButton *loadMoreButton;
- (IBAction)loadMoreAction:(id)sender;
@property (weak, nonatomic) id <LoadMoreActionDelaegate> loadDelegate;
-  (instancetype)initWithFrame:(CGRect)frame;
@end
