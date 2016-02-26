//
//  PathDrawView.m
//  旅游季
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "PathDrawView.h"
#import "PathDetailModel.h"

#define PointMargin 60
#define VerMargin 15
#define pathLabel_W 130


@implementation PathDrawView

- (void)setPathArr:(NSArray *)pathArr{
    
    _pathArr = pathArr;
    [self setNeedsDisplay];
    _view_w = PointMargin*(pathArr.count+1);
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
    CGFloat halfH = self.frame.size.height/2;
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 55/255.0, 180/255.0, 255/255.0, 1);
    CGContextSetRGBFillColor(ctx, 55/255.0, 180/255.0, 255/255.0, 1);
    NSMutableArray *pointArrM = [[NSMutableArray alloc]init];
    int j = 1;
    for (int i = 0;i<_pathArr.count; i++) {
         j=-j;
        CGPoint point = CGPointMake((i+1)*PointMargin, j*VerMargin+halfH);
        CGContextAddArc(ctx, point.x, point.y, 5, 0, M_PI*2, 1);
        CGContextFillPath(ctx);
       
        NSValue *pointValue = [NSValue valueWithCGPoint:point];
        [pointArrM addObject:pointValue];
        
        
        PathDetailModel *pathModel = _pathArr[i];
        NSString *pathName = pathModel.name;
        
        CGContextSaveGState(ctx);
        UIFont *font = [UIFont systemFontOfSize:13];
        UIColor *color = [UIColor lightGrayColor];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        NSTextAlignment align = NSTextAlignmentCenter;
        style.alignment = align;
        CGFloat nameLY = j==1?j*(VerMargin+10)+halfH:j*(VerMargin+25)+halfH;
        
        [pathName drawInRect:CGRectMake(point.x-pathLabel_W/2,nameLY, pathLabel_W, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style}];
        CGContextRestoreGState(ctx);
    };


    for (int i = 0; i<pointArrM.count; i++) {
        CGPoint point = [pointArrM[i] CGPointValue];
        if (i==0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        }else {
            
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
        if (i==pointArrM.count-1) {
                CGContextStrokePath(ctx);
        }
 
    }
    
}


@end
