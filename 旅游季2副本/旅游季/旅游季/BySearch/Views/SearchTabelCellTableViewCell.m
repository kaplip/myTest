//
//  SearchTabelCellTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "SearchTabelCellTableViewCell.h"
#import "UIImageView+WebCache.h"

#define  viewMargin 10
#define imageWidth 100
#define ScreenW  [UIScreen mainScreen].bounds.size.width

@interface SearchTabelCellTableViewCell()

@property (strong, nonatomic) UIImageView *imageShowView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detileLabel;

@property (strong, nonatomic) UILabel *isgoodLabel;

@end


@implementation SearchTabelCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return  self;
}

- (void)initUI{
    
    UIView *topMarginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 8)];
    [topMarginView setBackgroundColor: mainColor];
    
    _imageShowView = [[UIImageView alloc]initWithFrame:CGRectMake(viewMargin,viewMargin+8,imageWidth, imageWidth)];
   
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageWidth+2*viewMargin, viewMargin+8, ScreenW-imageWidth-3*viewMargin, 30)];
    _titleLabel.font  = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor orangeColor];
   
    
    _detileLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+viewMargin, _titleLabel.frame.size.width, imageWidth - viewMargin-30)];
    _detileLabel.numberOfLines = 4;
    _detileLabel.font = [UIFont systemFontOfSize:12];
 
    UIView *BottomMarginView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_detileLabel.frame)+viewMargin, ScreenW, 8)];
    [BottomMarginView setBackgroundColor:mainColor];
    
    [self addSubview:_imageShowView];
    [self addSubview:_titleLabel];
    [self addSubview:_detileLabel];
    [self addSubview:BottomMarginView];
    [self addSubview:topMarginView];
}

- (void)setSearchModel:(BySearchModel *)searchModel{
    
    _searchModel = searchModel;
     [_imageShowView sd_setImageWithURL:[NSURL URLWithString:searchModel.imageUrl]];
     [_titleLabel setText:searchModel.title];
     [_detileLabel setText:searchModel.content];
}
@end
