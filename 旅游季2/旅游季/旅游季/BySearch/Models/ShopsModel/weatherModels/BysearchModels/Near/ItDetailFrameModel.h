//
//  ItDetailFrameModel.h
//  旅游季
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ItinerarieDetailModel;
@interface ItDetailFrameModel : NSObject

@property (assign, readonly, nonatomic) CGRect indexLabelR;
@property (assign, readonly, nonatomic) CGRect pathLineViewR;
@property (assign, readonly, nonatomic) CGRect desR;
@property (assign, readonly, nonatomic) CGRect dinningLabelR;
@property (assign, readonly, nonatomic) CGRect accomLabelR;

@property (assign, nonatomic) CGFloat cellHeight;

@property (strong, nonatomic) ItinerarieDetailModel *itDetailModel;

@end
