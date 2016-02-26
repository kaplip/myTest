//
//  CustomCell.m
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "CustomCell.h"

#define LabelMargin 5

@interface CustomCell()



@end

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.frame  = frame;
        self.userInteractionEnabled  = YES;
    }
    return self;
}



- (void)setSortTitle:(NSString *)sortTitle{
    
    if (_sortTitle==nil) {
        _sortTitle = sortTitle;
        [self initUI];
    }
}

- (void)setImageName:(NSString *)imageName{
    
    if (_imageName==nil) {
        _imageName = imageName;
    }
}
- (void)setSortTag:(NSInteger)sortTag{
        _sortTag = sortTag;
}

- (void)initUI{
    
    UIImageView *sortImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    [sortImage setImage:[UIImage imageNamed:_imageName]];
    
    sortImage.layer.cornerRadius = 7.0;
    sortImage.clipsToBounds = YES;
    sortImage.layer.borderColor = [UIColor yellowColor].CGColor;
    
    UILabel *sortLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height+LabelMargin, 0, 50, self.frame.size.height)];
    sortLabel.text = _sortTitle;
    sortLabel.font = [UIFont systemFontOfSize:13];
    sortLabel.textColor = [UIColor blackColor];
    sortLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];

    if (_sortTag) {
        button.tag = _sortTag;
    }
    
    [self addSubview:button];
    [self insertSubview:sortImage belowSubview:button];
    [self insertSubview:sortLabel belowSubview:button];
}

- (void)buttonOnClick:(CustomCell *)cell{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sortButtonOnClick:)]) {
        [self.delegate sortButtonOnClick:self];
    }
}

@end
