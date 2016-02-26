//
//  ShopDetailHeaderView.m
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ShopDetailHeaderView.h"
#import "ShopDetailModel.h"

@interface ShopDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageV;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleL;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;


@end


@implementation ShopDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ShopDetailHeaderView" owner:nil options:nil].lastObject;
    }
    return self;
}


- (void)setShopDetailModel:(ShopDetailModel *)shopDetailModel{
    _shopDetailModel = shopDetailModel;
    _shopImageV.image = [UIImage imageWithData:_shopDetailModel.titleImageData];
    _shopTitleL.text = _shopDetailModel.shop_name;
    _phoneNumL.text = _shopDetailModel.phone;
    _addressL.text = _shopDetailModel.address;
}


@end
