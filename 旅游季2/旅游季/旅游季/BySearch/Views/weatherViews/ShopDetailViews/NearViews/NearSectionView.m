//
//  NearSectionView.m
//  旅游季
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "NearSectionView.h"
#import "ItinerarieModel.h"

#define Screen_W  [UIScreen mainScreen].bounds.size.width
#define SecMargin 5

@interface NearSectionView()

@property (strong, nonatomic) UILabel *nameL;
@property (strong, nonatomic) UILabel *desL;

@end

@implementation NearSectionView{
    
    BOOL selected;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor redColor];
        [self setupUI];
      
    }
    return self;
}

- (void)setupUI{
    
   
    _nameL  = [[UILabel alloc]initWithFrame:CGRectMake(0, SecMargin*3, Screen_W, 30)];
    _desL = [[UILabel alloc]init];
    
    _nameL.textAlignment = NSTextAlignmentCenter;
    _nameL.font = [UIFont systemFontOfSize:30];
    _desL.textAlignment = NSTextAlignmentCenter;
    _desL.font = ListFont;
    [_desL setTextColor:[UIColor lightGrayColor]];
    [self addSubview:_nameL];
    [self insertSubview:_desL aboveSubview:_nameL];
}

-  (void)setItinerarieModel:(ItinerarieModel *)itinerarieModel{
    
    _itinerarieModel = itinerarieModel;
    _nameL.text = itinerarieModel.name;
    _desL.text = itinerarieModel.Description;
    _desL.numberOfLines = 0;
    CGSize sourceSize = CGSizeMake(Screen_W/7*5, MAXFLOAT);
    CGSize resultSize = [_desL.text boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ListFont} context:nil].size;
    [_desL setFrame:CGRectMake(Screen_W/7, _nameL.frame.size.height+SecMargin*4, Screen_W/7*5, resultSize.height)];
    
    [self initShodwLayer];
    _sectionHeaderH = CGRectGetMaxY(_desL.frame)+SecMargin*2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, Screen_W, _sectionHeaderH)];
    [button addTarget:self action:@selector(cilckSection:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)initShodwLayer{

    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(5,-5);
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [self setBackgroundColor:[UIColor whiteColor]];
 
}

- (void)cilckSection:(UIButton *)button{
    

        if (self.delegate && [self.delegate respondsToSelector:@selector(selectSectionAction:)]) {
            [self.delegate selectSectionAction:self];
        }

}

@end
