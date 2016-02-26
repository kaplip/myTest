//
//  DealFrameModel.m
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "DealFrameModel.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define elemMargin 7

#define  ImageW 70
#define  ImageH 50

@implementation DealFrameModel

- (void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
    
    [self setImageVFrame];
    [self setTitleFrame];
    [self setDesLabelFrame];
    [self setSaleNumFrame];
    [self setScoreFrame];
    [self setCellHeight];
}

- (void)setImageVFrame{
    _dealImageVRec  = CGRectMake(elemMargin, elemMargin, ImageW, ImageH);
}

- (void)setTitleFrame{
    
    CGFloat imageMaxX = CGRectGetMaxX(_dealImageVRec);
    CGSize sourceSize = CGSizeMake(Screen_W-imageMaxX-elemMargin*2, MAXFLOAT);
    
    NSString *str = _dealModel.min_title;
    UIFont *font = ListFont;
    CGRect resultRect = [str boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil];
    
    
    _dealTitleLRec = CGRectMake(imageMaxX+elemMargin, elemMargin, resultRect.size.width, resultRect.size.height);
}

- (void)setDesLabelFrame{
    
    CGFloat title_x = _dealTitleLRec.origin.x;
    CGFloat title_maxY  = CGRectGetMaxY(_dealTitleLRec);
    CGFloat imageMaxX = CGRectGetMaxX(_dealImageVRec);
    
    CGSize sourceSize = CGSizeMake(Screen_W-imageMaxX-elemMargin*2, MAXFLOAT);
    
    NSString *str = _dealModel.Description;
    UIFont *font = DetileFont;
    CGRect resultRect = [str boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil];
    
    _desLabelRec = CGRectMake(title_x, title_maxY+elemMargin, resultRect.size.width, resultRect.size.height);
    
}

- (void)setSaleNumFrame{
    CGFloat title_x = CGRectGetMaxX(_dealImageVRec)+elemMargin;
    CGFloat title_maxY  = CGRectGetMaxY(_desLabelRec);
    
    CGSize sourceSize = CGSizeMake(150, MAXFLOAT);
    
    NSString *str =_dealModel.sale_numStr;
    UIFont *font = DetileFont;
    CGRect resultRect = [str boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil];
    
    _sale_numLRec = CGRectMake(title_x, title_maxY+elemMargin, resultRect.size.width, resultRect.size.height);
}


- (void)setScoreFrame{
    
    CGFloat y =_sale_numLRec.origin.y;
    CGSize sourceSize = CGSizeMake(100, MAXFLOAT);
    
    NSString *str = _dealModel.score;
    UIFont *font = DetileFont;
    CGRect resultRect = [str boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil];
    
    _scoreLRec = CGRectMake(Screen_W - elemMargin - 100, y, resultRect.size.width, resultRect.size.height);

}

- (void)setCellHeight{
    
    CGFloat maxY = CGRectGetMaxY(_sale_numLRec);
    
    _cellHeight = maxY+elemMargin;
}
@end
