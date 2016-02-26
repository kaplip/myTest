//
//  ProfileTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ProfileCollectionViewCell.h"
#import "ProfileViewCellFrame.h"
#import "ShareModel.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@interface ProfileCollectionViewCell()

@property (strong, nonatomic) NSMutableArray *imageViewArr;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;
@property (strong, nonatomic) UIButton *isGoodButton;
@property (strong, nonatomic) UIButton *critiqueButton;
@property (strong, nonatomic) UILabel *isGoodNumberLabel;
@property (strong, nonatomic) UILabel *critiqueNumberLabel;
@property (strong, nonatomic) UIView *marginView;


@end

@implementation ProfileCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ProfileTableViewCell" owner:nil options:nil].lastObject;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (UIView *)marginView{
    
    if (_marginView==nil) {
       _marginView = [[UIView alloc]init];
        [_marginView setBackgroundColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]];
        [self addSubview:_marginView];
    }
    return _marginView;
}

- (UILabel *)contentLabel{
    
    if (_contentLabel==nil) {
        _contentLabel = [[UILabel alloc]init];
        [_contentLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)isGoodNumberLabel{
    
    if (_isGoodNumberLabel == nil) {
        _isGoodNumberLabel = [[UILabel alloc]init];
        _isGoodButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isGoodButton setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
        _isGoodNumberLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_isGoodButton];
        [self addSubview:_isGoodNumberLabel];
    }
    return _isGoodNumberLabel;
}

- (UILabel *)critiqueNumberLabel{
    
    if (_critiqueNumberLabel == nil) {
        
        _critiqueNumberLabel = [[UILabel alloc]init];
        _critiqueButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [_critiqueButton setBackgroundImage:[UIImage imageNamed:@"eyeIcon"] forState:UIControlStateNormal];
         _critiqueNumberLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_critiqueButton];
        [self addSubview:_critiqueNumberLabel];
    }
    return  _critiqueNumberLabel;
}


- (NSMutableArray *)imageViewArr{
    
    if (_imageViewArr==nil) {
           _imageViewArr = [[NSMutableArray alloc]initWithCapacity:[_frameModel.shareModel.imageCount intValue]];
        for (int i =0; i<[_frameModel.shareModel.imageCount intValue]; i++) {
            UIImageView *tempImageView = [[UIImageView alloc]init];
            [self addSubview:tempImageView];
            [_imageViewArr addObject:tempImageView];

        }
    }
    return _imageViewArr;
}



- (void)setFrameModel:(ProfileViewCellFrame *)frameModel{

    _frameModel = frameModel;
    _headerImageV.layer.cornerRadius = _headerImageV.frame.size.width/2;
    _headerImageV.clipsToBounds = YES;
    [self clearUI];

    ShareModel *shareModel =_frameModel.shareModel;
   
    _positionLabel.text = shareModel.post_position;
    _timeLabel.text = shareModel.post_time;
    
    if (shareModel.imageArr.count!=0) {
        for (int i=0; i<[shareModel.imageCount intValue]; i++) {
            ImageModel *imageModel = shareModel.imageArr[i];
                UIImageView *tempImageView = self.imageViewArr[i];
                [tempImageView setFrame:[frameModel.imagesR[i] CGRectValue]];
                [tempImageView setBackgroundColor:[UIColor lightGrayColor]];
            [tempImageView sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrl] ];
        }
    }else{
       
    }
    
    
    self.contentLabel.text = shareModel.list_content;
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentLabel setNumberOfLines:0];
 
   
    self.isGoodNumberLabel.text = [NSString stringWithFormat:@"%@",shareModel.praise_number];
    self.critiqueNumberLabel.text = [NSString stringWithFormat:@"%@",shareModel.critique_number];
    
 
    
    [self.contentLabel setFont:ListFont];
    [self.contentLabel setFrame:_frameModel.contentLabelR];
    [self.isGoodButton setFrame:_frameModel.isGoodButtonR];
    [self.isGoodNumberLabel setFrame:_frameModel.isGoodNumR];
    [self.critiqueButton setFrame:_frameModel.critiqueButtonR];
    [self.critiqueNumberLabel setFrame:_frameModel.critiqueNumR];
    
    
    [self.marginView setFrame:_frameModel.marginR];

    [shareModel requestAuthor:^(UserModel *resultAuthor) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [_headerImageV sd_setImageWithURL:[NSURL URLWithString:resultAuthor.headerImageUrl]];
        }];
    }];
}


- (void)clearUI{

    for (UIView *imageV in self.imageViewArr) {
        [imageV removeFromSuperview];
        self.imageViewArr = nil;
    }
    
}
@end
