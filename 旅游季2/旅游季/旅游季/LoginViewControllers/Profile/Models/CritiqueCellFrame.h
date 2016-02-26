//
//  CritiqueCellFrame.h
//  旅游季
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CritiqueModel.h"
@interface CritiqueCellFrame : NSObject

@property (strong, nonatomic)CritiqueModel *critiqueModel;


@property (assign, readonly, nonatomic) CGRect headerR;
@property (assign,readonly, nonatomic) CGRect user_nameR;
@property (assign, readonly, nonatomic) CGRect creatTimeR;
@property (assign,readonly, nonatomic) CGRect contentR;
@property (assign, readonly, nonatomic) CGFloat cell_height;

@end
