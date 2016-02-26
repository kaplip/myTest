//
//  ProfileViewCellFrame.h
//  旅游季
//
//  Created by niit on 16/1/9.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ShareModel;
typedef void (^ SetComplete)(id result);

@interface ProfileViewCellFrame : NSObject

@property (strong, readonly, nonatomic) NSArray *imagesR;

@property (assign, readonly, nonatomic) CGRect contentLabelR;

@property (assign, readonly, nonatomic) CGRect isGoodButtonR;
@property (assign, readonly, nonatomic) CGRect  critiqueButtonR;
@property (assign, readonly, nonatomic) CGRect  isGoodNumR;
@property (assign, readonly, nonatomic) CGRect critiqueNumR;

@property (assign, readonly, nonatomic) CGRect marginR;

@property (strong, nonatomic) ShareModel *shareModel;

@property (assign, nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) SetComplete complete;
- (void)setFrame;
@end
