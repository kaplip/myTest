//
//  ShopDetailHeaderView.h
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopDetailModel;
@protocol ShopDetailLookForDelegate <NSObject>

- (void)lookforShopOnMap:(UIButton *)sender;

@end

@interface ShopDetailHeaderView : UIView

@property (weak, nonatomic) id <ShopDetailLookForDelegate> delegate;

@property (strong, nonatomic) ShopDetailModel *shopDetailModel;

@end
