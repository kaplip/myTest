//
//  DealFrameModel.h
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DealModel.h"

@interface DealFrameModel : NSObject

@property (assign, readonly, nonatomic) CGRect dealImageVRec;
@property (assign, readonly, nonatomic) CGRect dealTitleLRec;
@property (assign, readonly, nonatomic) CGRect desLabelRec;
@property (assign, readonly, nonatomic) CGRect sale_numLRec;
@property (assign, readonly, nonatomic) CGRect scoreLRec;

@property (assign, readonly, nonatomic) CGFloat cellHeight;

@property (strong, nonatomic) DealModel *dealModel;

@end
