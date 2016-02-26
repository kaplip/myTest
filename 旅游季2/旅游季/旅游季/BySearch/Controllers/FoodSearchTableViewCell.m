//
//  FoodSearchTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/16.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "FoodSearchTableViewCell.h"
#import "ShopModel.h"
@interface FoodSearchTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageV;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleL;
@property (weak, nonatomic) IBOutlet UILabel *dealNumberL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;


@end


@implementation FoodSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"FoodSearchTableViewCell" owner:nil options:nil].lastObject;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return  self;
}

-  (void)setShopModel:(ShopModel *)shopModel{
    
    _shopModel = shopModel;
    
    [_shopModel reloadImageData:^(id imageData) {
        NSData *data = (NSData *)imageData;
        UIImage *titleImage = [UIImage imageWithData:data];
        
        self.shopImageV.image = titleImage;
    }];
    
    _shopTitleL.text = _shopModel.shop_name;
    _distanceL.text = [NSString stringWithFormat:@"距离：%i米",[_shopModel.distance intValue]] ;
    _dealNumberL.text = [NSString stringWithFormat:@"%lu",(unsigned long)_shopModel.dealsModelArr.count] ;
    
}

@end
