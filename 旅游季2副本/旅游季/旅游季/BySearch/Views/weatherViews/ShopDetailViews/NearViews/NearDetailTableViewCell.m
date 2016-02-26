//
//  NearDetailTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "NearDetailTableViewCell.h"
#import "ItinerarieDetailModel.h"
#import "ItDetailFrameModel.h"
#import "PathDrawView.h"

#define Scree_W  [UIScreen mainScreen].bounds.size.width
#define ImageV_H 180


@interface NearDetailTableViewCell()<UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *indexLabel;

@property (strong, nonatomic) UIScrollView *pathScrollV;
@property (strong, nonatomic) PathDrawView *pathLinView;
@property (strong, nonatomic) UILabel *desL;
@property (strong, nonatomic) UILabel *dinningLabel;
@property (strong, nonatomic) UILabel *accommLabel;

@end

@implementation NearDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    _indexLabel = [[UILabel alloc]init];
    _desL = [[UILabel alloc]init];
    _pathScrollV = [[UIScrollView alloc]init];
    _accommLabel = [[UILabel alloc]init];
    _dinningLabel = [[UILabel alloc]init];
    
    [_pathScrollV setBackgroundColor:[UIColor clearColor]];
    [_indexLabel setFont:[UIFont systemFontOfSize:25]];
    [_desL setFont:ListFont];
    [_accommLabel setFont:ListFont];
    [_dinningLabel setFont:ListFont];
    
     [_desL setNumberOfLines:0];
     [_accommLabel setNumberOfLines:0];
     [_dinningLabel setNumberOfLines:0];
    
    [_desL setTextColor:[UIColor lightGrayColor]];
    [_accommLabel setTextColor:[UIColor lightGrayColor]];
    [_dinningLabel setTextColor:[UIColor lightGrayColor]];
    
    [self.contentView addSubview:_indexLabel];
    [self.contentView addSubview:_desL];
    [self.contentView addSubview:_pathScrollV];
    [self.contentView addSubview:_accommLabel];
    [self.contentView addSubview:_dinningLabel];
    
    _pathScrollV.showsHorizontalScrollIndicator = NO;
    _pathScrollV.showsVerticalScrollIndicator = NO;
    _pathScrollV.delegate = self;
    
    _pathLinView = [[PathDrawView alloc]init];
    [_pathLinView setBackgroundColor:[UIColor clearColor]];
    [_pathScrollV addSubview:_pathLinView];
}


- (void)setItDetailFrameModel:(ItDetailFrameModel *)itDetailFrameModel{
    _itDetailFrameModel = itDetailFrameModel;
    ItinerarieDetailModel *itdetailMode = _itDetailFrameModel.itDetailModel;
    
    _indexLabel.text = [NSString stringWithFormat:@"%i DAY",_index];
    _indexLabel.textAlignment  = NSTextAlignmentCenter;
    [_indexLabel setFrame:_itDetailFrameModel.indexLabelR];

    [_pathScrollV setFrame:_itDetailFrameModel.pathLineViewR];
    [_desL setFrame:_itDetailFrameModel.desR];
    [_accommLabel setFrame:_itDetailFrameModel.accomLabelR];
    [_dinningLabel setFrame:_itDetailFrameModel.dinningLabelR];
    
    
    [_desL setText:itdetailMode.Description];
    [_accommLabel setText:itdetailMode.accommodation];
    [_dinningLabel setText:itdetailMode.dinning];
    
   
    _pathLinView.pathArr =itdetailMode.pathDetailModel;
    [_pathLinView setFrame:CGRectMake(0, 0, _pathLinView.view_w, _pathScrollV.frame.size.height)];
    [_pathScrollV setContentSize:CGSizeMake(_pathLinView.frame.size.width, 0)];
  
}



@end
