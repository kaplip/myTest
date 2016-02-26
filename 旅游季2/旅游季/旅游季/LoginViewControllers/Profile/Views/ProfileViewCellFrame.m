//
//  ProfileViewCellFrame.m
//  旅游季
//
//  Created by niit on 16/1/9.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ProfileViewCellFrame.h"
#import "ShareModel.h"
#import "UIImage+WebP.h"
#import "ImageModel.h"
#define Margin 10
#define BottomButtonMargin 20
#define ScreenW [UIScreen mainScreen].bounds.size.width


@implementation ProfileViewCellFrame



- (void)setShareModel:(ShareModel *)shareModel{
    if (_shareModel==nil) {
        _shareModel = shareModel;
        [self setFrame];
    }
}

- (void)setFrame{
    
    CGFloat headerImage_maxy = 58;
    
   __block CGFloat imageViewMaxH = 0.0;
    
  
        if (_shareModel.imageArr.count!=0){
            NSMutableArray *tempRectArrM = [[NSMutableArray alloc]init];
            CGFloat imageView_W = Cell_W(Margin, 1);
            for (int i = 0; i<_shareModel.imageArr.count; i++) {
                ImageModel *imageModel = _shareModel.imageArr[i];
                CGFloat  imageScale =imageModel.image_H/imageModel.image_W;
                CGFloat imageView_H = imageView_W*imageScale;
                CGRect imageRect = CGRectMake(
                                              0,
                                              headerImage_maxy+(Margin+imageView_H)*i,
                                              imageView_W,
                                              imageView_H);
                
                NSValue *value = [NSValue valueWithCGRect:imageRect];
                
                [tempRectArrM addObject:value];
                
                imageViewMaxH = CGRectGetMaxY(imageRect);
            }
            
            _imagesR = [tempRectArrM copy];
        } else{
            
            imageViewMaxH = 0.0;
        }
        [self setLabelFrame:imageViewMaxH];

}

- (void)setLabelFrame:(CGFloat)imageViewMaxH{
    
    UIFont *font = ListFont;
    CGSize messageSize = CGSizeMake(Cell_W(Margin, 2)-2*Margin, MAXFLOAT);
    
    
    CGSize messageResultSize = [_shareModel.list_content
                                boundingRectWithSize:messageSize
                                options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:font}
                                context:nil].size;
    
    _contentLabelR = CGRectMake(
                                Margin,
                                imageViewMaxH+Margin,
                                messageResultSize.width,
                                messageResultSize.height);
    
    
    
    CGFloat message_maxY = CGRectGetMaxY(_contentLabelR);
    
    _isGoodButtonR = CGRectMake(0, message_maxY+Margin, 20, 20);
    
    _isGoodNumR = CGRectMake(20+Margin+0, message_maxY+Margin, 50, 20);
    
    _critiqueNumR = CGRectMake(Cell_W(Margin, 2)-40, message_maxY+Margin, 50, 20);
    CGFloat critiqueNum_originX = CGRectGetMinX(_critiqueNumR);
    _critiqueButtonR = CGRectMake(critiqueNum_originX- Margin-20, message_maxY+Margin, 20, 20);
    
    CGFloat button_maxY = CGRectGetMaxY(_isGoodButtonR);
    _marginR = CGRectMake(0, button_maxY+Margin, Cell_W(Margin, 2), 0);
    
    _cellHeight = CGRectGetMaxY(_marginR);
    
}
@end
