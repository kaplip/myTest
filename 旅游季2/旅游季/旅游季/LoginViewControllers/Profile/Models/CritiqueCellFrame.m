//
//  CritiqueCellFrame.m
//  旅游季
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "CritiqueCellFrame.h"
#define margin 10
#define Screen_W     [UIScreen mainScreen].bounds.size.width
@implementation CritiqueCellFrame

- (void)setCritiqueModel:(CritiqueModel *)critiqueModel{
    
    _critiqueModel = critiqueModel;
    
    [self setHeaderR];
    [self setUserNameR];
    [self setCreatTimeR];
    [self setContenR];
    
}

- (void)setHeaderR{
    
    _headerR = CGRectMake(margin, margin, 40, 40);
    
}

- (void)setUserNameR{

    CGFloat _headerX = CGRectGetMaxX(_headerR);
    _user_nameR = CGRectMake(_headerX+margin, margin, 100,15);
    
}


- (void)setCreatTimeR{
    
    CGFloat user_nameY = CGRectGetMaxY(_user_nameR);
    CGFloat user_nameX = CGRectGetMinX(_user_nameR);
    _creatTimeR = CGRectMake(user_nameX,user_nameY+margin, Screen_W - 20-user_nameX, 15);
}

- (void)setContenR{
    
    CGFloat _creatTiemY = CGRectGetMaxY(_creatTimeR);
    
    NSString *content  = _critiqueModel.content;
    UIFont *font = [UIFont systemFontOfSize:13];
    
    CGSize sourceSize = CGSizeMake(Screen_W-20, MAXFLOAT);
    CGSize resultSzie = [content boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    _contentR = CGRectMake(margin, _creatTiemY+margin, resultSzie.width, resultSzie.height);
    _cell_height = CGRectGetMaxY(_contentR)+margin;
}
@end
