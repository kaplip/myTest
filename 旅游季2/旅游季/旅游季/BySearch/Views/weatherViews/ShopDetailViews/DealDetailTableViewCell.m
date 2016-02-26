//
//  DealDetailTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "DealDetailTableViewCell.h"
#import "DealFrameModel.h"
#import "DealModel.h"
@interface DealDetailTableViewCell()

@property (strong, nonatomic) UIImageView *dealImageV;
@property (strong, nonatomic) UILabel *dealTitleL;
@property (strong, nonatomic) UILabel *desLabel;

@property (strong, nonatomic) UILabel *sale_numL;
@property (strong, nonatomic) UILabel *scoreL;

@end


@implementation DealDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
        
    }
    return self;
}

- (void)initUI{

    _dealImageV = [[UIImageView alloc]init];
    _dealTitleL = [[UILabel alloc]init];
    _desLabel = [[UILabel alloc]init];
    _sale_numL = [[UILabel alloc]init];
    _scoreL = [[UILabel alloc]init];
    
    [_dealTitleL setFont:ListFont];
    [_desLabel setFont:DetileFont];
    [_sale_numL setFont:DetileFont];
    [_scoreL setFont:DetileFont];
    
    [_dealTitleL setNumberOfLines:0];
    [_desLabel setNumberOfLines:0];
    [_sale_numL setNumberOfLines:0];
    [_scoreL setNumberOfLines:0];
    
    [_desLabel setTextColor:[UIColor lightGrayColor]];
    [_sale_numL setTextColor:[UIColor lightGrayColor]];
    [_scoreL setTextColor:[UIColor lightGrayColor]];
    
    [self.contentView addSubview:_dealImageV];
    [self.contentView addSubview:_dealTitleL];
    [self.contentView addSubview:_desLabel];
    [self.contentView addSubview:_sale_numL];
    [self.contentView addSubview:_scoreL];
}

- (void)setDealFrameModel:(DealFrameModel *)dealFrameModel{
    _dealFrameModel = dealFrameModel;
    DealModel *dealModel = _dealFrameModel.dealModel;
    
    [dealModel fecthImage:^(id ImageData) {
        NSData *imageData = (NSData *)ImageData;
        _dealImageV.image = [UIImage imageWithData:imageData];
        
    }];
    
    [_dealImageV setFrame:_dealFrameModel.dealImageVRec];
    [_dealTitleL setFrame:_dealFrameModel.dealTitleLRec];
    [_desLabel setFrame:_dealFrameModel.desLabelRec];
    [_sale_numL setFrame:_dealFrameModel.sale_numLRec];
    [_scoreL setFrame:_dealFrameModel.scoreLRec];
    
    [_dealTitleL setText:dealModel.min_title];
    [_desLabel setText:dealModel.Description];
    [_sale_numL setText:dealModel.sale_numStr];
    [_scoreL setText:dealModel.score];
}

@end
