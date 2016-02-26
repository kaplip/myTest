
//
//  ItDetailFrameModel.m
//  旅游季
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ItDetailFrameModel.h"
#import "ItinerarieDetailModel.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define IndexL_W 200
#define IndexL_H 50
#define DetailMargin 7

@implementation ItDetailFrameModel

- (void)setItDetailModel:(ItinerarieDetailModel *)itDetailModel{
    
    _itDetailModel = itDetailModel;
    
    [self setIndexLabelR];
    [self setPathLineViewR];
    [self setDesR];
    [self setDinningLabelR];
    [self setCommLabelR];
    
    _cellHeight = CGRectGetMaxY(_accomLabelR)+DetailMargin;
}

- (void)setIndexLabelR{
    
    _indexLabelR =CGRectMake((Screen_W-IndexL_W)/2,DetailMargin , IndexL_W, IndexL_H);
}

- (void)setPathLineViewR{
    CGFloat indexLabelMaxY = CGRectGetMaxY(_indexLabelR)+DetailMargin;
    _pathLineViewR = CGRectMake(0, indexLabelMaxY+DetailMargin, Screen_W, 100);
}

- (void)setDesR{
    
    NSString *desStr = [NSString stringWithFormat:@"      %@",_itDetailModel.Description];
    CGFloat pathLinVMaxY = CGRectGetMaxY(_pathLineViewR)+DetailMargin*3;
    UIFont *font = ListFont;
    _desR = [self resultRectWith:desStr andMaxY:pathLinVMaxY andFont:font];
}

- (void)setDinningLabelR{
    
    NSString *dinner = [NSString stringWithFormat:@"美食推荐:%@",_itDetailModel.dinning];
    CGFloat desRMaxY = CGRectGetMaxY(_desR)+DetailMargin*3;
    UIFont *font = ListFont;
    _dinningLabelR = [self resultRectWith:dinner andMaxY:desRMaxY andFont:font];
}

- (void)setCommLabelR{
    
    NSString *commStr =[NSString stringWithFormat:@"  住宿推荐%@:",_itDetailModel.accommodation];
    CGFloat dinMaxY = CGRectGetMaxY(_dinningLabelR)+DetailMargin*3;
    UIFont *font = ListFont;
    _accomLabelR = [self resultRectWith:commStr andMaxY:dinMaxY andFont:font];
}

- (CGRect)resultRectWith:(NSString *)sourceStr andMaxY:(CGFloat)maxY andFont:(UIFont *)font{
    CGSize sourceSize = CGSizeMake(Screen_W, MAXFLOAT);
    CGSize resultSize = [sourceStr boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return CGRectMake(0, maxY,resultSize.width, resultSize.height);
}

@end
