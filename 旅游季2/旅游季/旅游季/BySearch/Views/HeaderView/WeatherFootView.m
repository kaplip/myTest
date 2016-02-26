//
//  WeatherFootView.m
//  旅游季
//
//  Created by niit on 16/1/16.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "WeatherFootView.h"
#import "WeatherModel.h"
#import "ForecastAndHistoryModel.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ForeMargin ScreenW/5
#define EachTemp 10

#define detailLabel_height 20

@interface WeatherFootView()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSArray *weatherArr;
@property (strong, nonatomic) NSMutableArray *lowPointArr;
@property (strong, nonatomic) NSMutableArray *hightPointArr;

@property (assign, nonatomic) CGFloat viewMaxH;

@end


@implementation WeatherFootView{
    
    CGFloat heightestT;
    CGFloat hei_lowest;//最低温度中的最大值
    
   
    CGFloat lowestPoint_y;//最低温度中的最小值
}


- (void)setWeatherModel:(WeatherModel *)weatherModel{
    
    _weatherModel = weatherModel;

    _weatherArr = [self fetchForeWeather];
    [self setTitleUPLabel];
    [self settingPointArr];
    [self setUPUI];
    [self setNeedsDisplay];
    
}

- (void)setTitleUPLabel{
    
   _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    _titleLabel.text = @" 未来几天:";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:_titleLabel];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (_weatherModel) {
        
        [self drawWeatherInfoWitnArr:_weatherArr];
        [self drawPointWithArr:self.lowPointArr withType:1];
        [self drawPointWithArr:self.hightPointArr withType:0];
    }
}
- (void)drawWeatherInfoWitnArr:(NSArray *)arrM{
    
    CGFloat start_Y = 35.0;
    CGFloat end_Y = self.frame.size.height-35.0;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for(int i = 0;i<arrM.count;i++){
        //绘制分割线
        if (i + 1 !=5) {
            CGContextMoveToPoint(ctx, (i + 1)*ForeMargin, start_Y);
            CGContextAddLineToPoint(ctx,  (i + 1)*ForeMargin, end_Y);
            CGContextSetLineWidth(ctx, 1);
            CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.5);
            CGContextStrokePath(ctx);
        }
    }
    
  
}


- (void)drawPointWithArr:(NSArray *)arr withType:(int)tempType{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i<arr.count; i++) {
        NSValue *pointValue = arr[i];
        CGPoint point = [pointValue CGPointValue];
        if (i==0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        }
        CGContextAddLineToPoint(ctx, point.x, point.y);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.7);
        if (i==self.lowPointArr.count-1) {
            CGContextStrokePath(ctx);
        }
    }
    
    for (int i = 0; i<arr.count; i++) {
        NSValue *pointValue = arr[i];
        CGPoint point = [pointValue CGPointValue];
        CGContextAddArc(ctx, point.x, point.y, 5, 0, 2*M_PI, 0.7);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
        CGContextFillPath(ctx);
        
        ForecastAndHistoryModel *model = _weatherArr[i];
        NSString *tempInfo;
       
        if (tempType==0) {
           tempInfo = model.hightemp;
        }else{
            tempInfo = model.lowtemp;
        }
        
        UIFont *font = [UIFont systemFontOfSize:12];
        UIColor *color = [UIColor whiteColor];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        NSTextAlignment align = NSTextAlignmentCenter;
        style.alignment = align;
        [tempInfo drawInRect:CGRectMake(point.x-ForeMargin/2, point.y-30, ForeMargin, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style}];
    };
    
}

- (void)setUPUI{
    CGFloat title_maxY = CGRectGetMaxY(_titleLabel.frame);
    for(int i = 0;i<_weatherArr.count;i++){
        
        ForecastAndHistoryModel *model = _weatherArr[i];
        //绘制每列的内容
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(ForeMargin*i, 0+title_maxY, ForeMargin, detailLabel_height)];
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake
                              (ForeMargin*i,
                               detailLabel_height+title_maxY,
                               ForeMargin,
                               detailLabel_height)];
        
        UIImageView *typeImageV = [[UIImageView alloc]initWithFrame:CGRectMake
                                   (ForeMargin*i+ForeMargin/4,
                                    lowestPoint_y+title_maxY,
                                    ForeMargin/2,
                                    ForeMargin/2)];
        CGFloat imageV_maxY = CGRectGetMaxY(typeImageV.frame);
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake
                              (ForeMargin*i,
                               imageV_maxY,
                               ForeMargin,
                               detailLabel_height)];
        UILabel *fengLabel = [[UILabel alloc]initWithFrame:CGRectMake
                              (ForeMargin*i,
                               imageV_maxY+detailLabel_height,
                               ForeMargin,
                               detailLabel_height)];
        
        NSString *dateStr = [[model.date substringFromIndex:4] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];

        weekLabel.text = model.week;
        typeLabel.text  = model.type;
        dateLabel.text = dateStr;
        fengLabel.text = model.fengli;
        typeImageV.image = [UIImage imageNamed:model.weatherImageName];
        
        [weekLabel setFont:[UIFont systemFontOfSize:15]];
        [typeLabel setFont:[UIFont systemFontOfSize:13]];
        [dateLabel setFont:[UIFont systemFontOfSize:10]];
        [fengLabel setFont:[UIFont systemFontOfSize:10]];
        
        weekLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        fengLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [weekLabel setTextColor:[UIColor whiteColor]];
        [typeLabel setTextColor:[UIColor whiteColor]];
        [dateLabel setTextColor:[UIColor whiteColor]];
        [fengLabel setTextColor:[UIColor whiteColor]];
        
        [self addSubview:weekLabel];
        [self addSubview:typeLabel];
        [self addSubview:dateLabel];
        [self addSubview:fengLabel];
        [self addSubview:typeImageV];
        
        _viewMaxH = CGRectGetMaxY(fengLabel.frame);
    }
    
}


- (NSMutableArray *)lowPointArr{
    if (_lowPointArr==nil) {
        _lowPointArr = [[NSMutableArray alloc]init];
    }
    return _lowPointArr;
}

- (NSMutableArray *)hightPointArr{
    if (_hightPointArr == nil) {
        _hightPointArr = [[NSMutableArray alloc]init];
    }
    return _hightPointArr;
}

- (void)settingPointArr{
    
    
    ForecastAndHistoryModel *model = _weatherArr[0];
     heightestT = [model.hightemp floatValue];
     hei_lowest= [model.lowtemp floatValue];
    for (int i = 0;  i<_weatherArr.count; i++) {
        ForecastAndHistoryModel *model = _weatherArr[i];
        CGFloat  heightTemp =[model.hightemp floatValue];
        CGFloat  lowTemp =[model.lowtemp floatValue];
        heightestT = heightestT>heightTemp?heightestT:heightTemp;
        hei_lowest = hei_lowest>lowTemp?hei_lowest:lowTemp;//求出最低温度中的最大值
      
    }
 
    for (int i = 0; i<_weatherArr.count; i++) {
        ForecastAndHistoryModel *model = _weatherArr[i];
        
        CGFloat  heitTemp =[model.hightemp floatValue];
        CGFloat lowTemp = [model.lowtemp floatValue];
       
        CGPoint tempHeight = CGPointMake(ForeMargin/2+ForeMargin*i,(heightestT-heitTemp)*EachTemp+detailLabel_height*6);
         CGPoint tempLow =CGPointMake(ForeMargin/2+ForeMargin*i,(hei_lowest-lowTemp)*EachTemp+tempHeight.y+100);

        NSValue *heghtValue = [NSValue valueWithCGPoint:tempHeight];
        NSValue *lowValue = [NSValue valueWithCGPoint:tempLow];

        [self.lowPointArr addObject:lowValue];
        [self.hightPointArr addObject:heghtValue];
        
    }
    
    //求出最低温度中的最小值
    lowestPoint_y =[self.lowPointArr[0] CGPointValue].y;
    
    for (int i = 0; i<self.lowPointArr.count; i++) {
        NSValue *pointValue = self.lowPointArr[i];
        CGPoint lowPoint = [pointValue CGPointValue];
        lowestPoint_y =lowestPoint_y>lowPoint.y?lowestPoint_y:lowPoint.y;
    }
}

- (NSArray *)fetchForeWeather{
   
    NSMutableArray *arrM = [[NSMutableArray alloc]init];
    ForecastAndHistoryModel *today = [[ForecastAndHistoryModel alloc]init];
    today.date = _weatherModel.date;
    today.week = @"今天";
    today.fengxiang = _weatherModel.fengxiang;
    today.fengli = _weatherModel.fengli;
    today.hightemp = _weatherModel.hightemp;
    today.lowtemp = _weatherModel.lowtemp;
    today.type = _weatherModel.type;
    today.weatherImageName = _weatherModel.weatherImageName;
    
    [arrM addObject:today];
    [arrM addObjectsFromArray:_weatherModel.forecastInfo];
    return [arrM copy];
}


- (CGFloat)getviewMaxH{
    
    return _viewMaxH+30;
    
}
@end
