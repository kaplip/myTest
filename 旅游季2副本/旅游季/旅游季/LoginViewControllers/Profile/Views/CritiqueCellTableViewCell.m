//
//  CritiqueCellTableViewCell.m
//  旅游季
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "CritiqueCellTableViewCell.h"
#import "CritiqueModel.h"
#import "CritiqueCellFrame.h"
@interface CritiqueCellTableViewCell()

@property (strong, nonatomic) UILabel *userNameL;
@property (strong, nonatomic) UILabel *creatTiameL;
@property (strong, nonatomic) UILabel *contentL;
@property (strong, nonatomic) UIImageView *headerImageV;



@end

@implementation CritiqueCellTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)setFrameModel:(CritiqueCellFrame *)frameModel{
    
    _frameModel = frameModel;
    CritiqueModel *critiqueModel = frameModel.critiqueModel;
    
    _userNameL.frame = frameModel.user_nameR;
    _creatTiameL.frame = frameModel.creatTimeR;
    _contentL.frame = frameModel.contentR;
    
    _userNameL.text = critiqueModel.userModel.user_name;
    _creatTiameL.text = critiqueModel.creatTime;
    _contentL.text = critiqueModel.content;
    
    _userNameL.font = [UIFont systemFontOfSize:14];
    _creatTiameL.font = [UIFont systemFontOfSize:13];
    _contentL.font = [UIFont systemFontOfSize:13];
    
    _userNameL.textColor = [UIColor blackColor];
    _creatTiameL.textColor = [UIColor lightGrayColor];
    _contentL.numberOfLines = 0;
    
    [_headerImageV setFrame:frameModel.headerR];
    [_headerImageV setImage:[UIImage imageWithData:critiqueModel.userModel.headerImageData]];
    [_headerImageV setBackgroundColor:[UIColor lightGrayColor]];
    _headerImageV.layer.cornerRadius = _headerImageV.frame.size.width/2;
    _headerImageV.clipsToBounds = YES;
}

- (void)initUI{
    
    _userNameL = [[UILabel alloc]init];
    _creatTiameL = [[UILabel alloc]init];
    _contentL = [[UILabel alloc]init];
    _headerImageV = [[UIImageView alloc]init];
    
    [self addSubview:_userNameL];
    [self addSubview:_creatTiameL];
    [self addSubview:_contentL];
    [self addSubview:_headerImageV];
}
@end
