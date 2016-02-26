//
//  NearHeaderView.m
//  旅游季
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 niit. All rights reserved.
//




#import "NearHeaderView.h"
#import "CityModel.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width

#define HeaderImgH 200
#define absL_H  80
#define des_H 130

#define Vertic 15
#define  Horiz 10

@interface  NearHeaderView()

@property (strong, nonatomic) UIImageView *headerImageV;
@property (strong, nonatomic) UILabel *cityLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *abstractL;
@property (strong, nonatomic) UILabel *desL;
@end

@implementation NearHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self setUI];
    }
    return self;
}

- (void)setCityModel:(CityModel *)cityModel{

        _cityModel = cityModel;
        [self setHeaderImgegeV];
        
}

- (void)setHeaderImgegeV{
    
    NSString *cityName  = _cityModel.cityname;
    
    _cityLabel.text = cityName;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YY-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    _dateLabel.text = dateStr;

    _abstractL.text  = [NSString stringWithFormat:@"       %@",_cityModel.abstract];
    
    
    [_abstractL setBackgroundColor:[UIColor whiteColor]];
    CGSize sourceSize = CGSizeMake(Screen_W, MAXFLOAT);
    CGSize resultSize = [_abstractL.text boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ListFont} context:nil].size;
    
    [_abstractL setFrame:CGRectMake(0, HeaderImgH, Screen_W, resultSize.height+16)];
   
    [_headerImageV setImage:[UIImage imageWithData:_cityModel.imageData]];
   
    _headerHeight = CGRectGetMaxY(_abstractL.frame)+10.0;
}

- (void)setUI{
    _headerImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,Screen_W ,HeaderImgH)];
    _headerImageV.layer.borderColor = [UIColor colorWithRed:63/255.0 green:131/255.0 blue:255/255.0 alpha:1].CGColor;
   
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, Screen_W/5*2, 30)];
    _cityLabel.font = [UIFont systemFontOfSize:30];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, Screen_W/5*2, 30)];
    _dateLabel.font = [UIFont systemFontOfSize:15];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    
     _abstractL  = [[UILabel alloc]init];
    _abstractL.font = ListFont;
    _abstractL.numberOfLines = 0;
    _abstractL.textColor = [UIColor lightGrayColor];
    
    [self addSubview:_headerImageV];
    [self addSubview:_abstractL];
    [self insertSubview:_cityLabel aboveSubview:_headerImageV];
    [self insertSubview:_dateLabel aboveSubview:_headerImageV];
}



@end
