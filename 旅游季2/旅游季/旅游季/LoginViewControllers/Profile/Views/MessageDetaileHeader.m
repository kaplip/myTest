//
//  MessageDetaileHeader.m
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "MessageDetaileHeader.h"
#import "ShareModel.h"
#import "ImageModel.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "Bmob+BmobDataModelTool.h"
#import "MBProgressHUD+MJ.h"

#define messageDetailMargin 10
#define Screen_W [UIScreen mainScreen].bounds.size.width


@interface  MessageDetaileHeader()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *tiamL;
@property (weak, nonatomic) IBOutlet UILabel *positionL;


@property (weak, nonatomic) UILabel *contentLabel;
@property (weak, nonatomic) UIButton *isgoodButton;
@property (weak, nonatomic) UIButton *critiqueButton;
@property (weak, nonatomic) UILabel *isgoodNumberL;
@property (weak, nonatomic) UILabel *critiqueNumberL;

@property (weak, nonatomic) UIImageView *imageV;

@property (strong, nonatomic) ShareModel *shareModel;

@property (strong, nonatomic) UIButton *commitButton;

@end

@implementation MessageDetaileHeader

- (instancetype)initWithShareModel:(ShareModel *)shareModel{
    if (self = [super init]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MessageDetaileHeader" owner:nil options:nil].lastObject;
        _shareModel = shareModel;
        [self setImageV];
        [self setContentL];
        [self setCommitButton];
        [self setDetailButton];
        [self setHeaderImageV];
       
        
        _nameL.text = shareModel.author.user_name;
        _tiamL.text = shareModel.post_time;
        _positionL.text = shareModel.post_position;
        
        CGFloat max_Y = CGRectGetMaxY(_isgoodButton.frame);
        [self setFrame:CGRectMake(0, 0, Screen_W, max_Y+messageDetailMargin)];
    }
    return self;
}


- (void)setImageV{
    CGFloat position_maxY = CGRectGetMaxY(_positionL.frame);
    
    for (int i = 0; i<_shareModel.imageArr.count; i++) {
        ImageModel *imageModel = _shareModel.imageArr[i];
        CGFloat imageScale = imageModel.image_W/imageModel.image_H;
        CGFloat imageV_H = Screen_W/imageScale;
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [imageV setFrame:CGRectMake(messageDetailMargin, position_maxY+messageDetailMargin, Screen_W-2*messageDetailMargin, imageV_H)];
        _imageV = imageV;
        [_imageV sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrl] ];
        [self addSubview:_imageV];
        
        
    }
    
}

- (void)setContentL{

    CGFloat position_maxY = CGRectGetMaxY(_imageV.frame);
    UIFont *font = [UIFont systemFontOfSize:13];
    NSString *content = _shareModel.list_content;
    
    CGSize sourceSize  = CGSizeMake(Screen_W-2*messageDetailMargin, MAXFLOAT);
    CGSize resultSize = [content boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    
    UILabel *tempContentL = [[UILabel alloc]initWithFrame:CGRectMake(messageDetailMargin, position_maxY+messageDetailMargin, Screen_W-2*messageDetailMargin, resultSize.height)];
    tempContentL.numberOfLines = 0;
    [tempContentL setFont:[UIFont systemFontOfSize:13]];
    tempContentL.text = content;
    _contentLabel = tempContentL;
    [self addSubview:_contentLabel];
}

- (void)setCommitButton{
    
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitButton setTitle:@"举报" forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _commitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_commitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setHeaderImageV{
    UserModel *user = _shareModel.author;
    [_headerImageV sd_setImageWithURL:[NSURL URLWithString:user.headerImageUrl]];
    _headerImageV.layer.cornerRadius  = _headerImageV.frame.size.width/2;
    _headerImageV.clipsToBounds = YES;
}

- (void)setDetailButton{
    
    CGFloat content_maxY = CGRectGetMaxY(_contentLabel.frame)+messageDetailMargin;
    UIButton *isgoodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [isgoodButton setFrame:CGRectMake(messageDetailMargin, content_maxY+messageDetailMargin, 25, 25)];
    [isgoodButton setBackgroundImage:[UIImage imageNamed:@"starIcon"] forState:UIControlStateNormal];
    _isgoodButton = isgoodButton;
    [_isgoodButton addTarget:self action:@selector(collectionMessageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat isGoodButton_maxX = CGRectGetMaxX(isgoodButton.frame);
    UILabel *isgoodNumL = [[UILabel alloc]initWithFrame:CGRectMake(isGoodButton_maxX+messageDetailMargin, content_maxY+messageDetailMargin, 50, 25)];
    isgoodNumL.text =[NSString stringWithFormat:@"%@",_shareModel.praise_number] ;
    [isgoodNumL setFont: [UIFont systemFontOfSize:13]];
    _isgoodNumberL = isgoodNumL;
    
    
    CGFloat isGoodL_MaxX = CGRectGetMaxX(isgoodNumL.frame);
    UIButton *critiqueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [critiqueButton setFrame:CGRectMake(isGoodL_MaxX+messageDetailMargin, content_maxY+messageDetailMargin, 25, 25)];
    [critiqueButton setBackgroundImage:[UIImage imageNamed:@"eyeIcon"] forState:UIControlStateNormal];
    _critiqueButton = critiqueButton;
    
    
    CGFloat critiqueButton_maxX = CGRectGetMaxX(critiqueButton.frame);
    UILabel *critiqueNumL = [[UILabel alloc]initWithFrame:CGRectMake(critiqueButton_maxX+messageDetailMargin, content_maxY+messageDetailMargin, 50, 25)];
    critiqueNumL.text =[NSString stringWithFormat:@"%@",_shareModel.critique_number] ;
    [critiqueNumL setFont:[UIFont systemFontOfSize:13]];
    _critiqueNumberL = critiqueNumL;
    
    
    CGFloat isGoodButton_Y = CGRectGetMinY(isgoodButton.frame);
    [_commitButton setFrame:CGRectMake(Screen_W-50-messageDetailMargin, isGoodButton_Y, 50, 30)];

   
    [self addSubview:_isgoodButton];
    [self addSubview:_isgoodNumberL];
    [self addSubview:_critiqueButton];
    [self addSubview:_critiqueNumberL];
    [self addSubview:_commitButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endEditingAction)]) {
        [self.delegate endEditingAction];
    }
}

- (void)collectionMessageAction{
    [Bmob modifeMessageInfoWithNotice:_shareModel andInsterAction:^(id result) {
        NSNumber *sucess = (NSNumber *)result;
        if ([sucess intValue]==0) {
            [MBProgressHUD showError:@"该动态你已收藏"];
        }else {
            [MBProgressHUD showSuccess:@"收藏成功"];
        }
    }] ;
}

- (void)commitAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitAction)]) {
        [self.delegate commitAction];
    }
    
}
@end
