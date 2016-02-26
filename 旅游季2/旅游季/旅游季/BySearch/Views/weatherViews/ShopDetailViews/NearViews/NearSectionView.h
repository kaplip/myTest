//
//  NearSectionView.h
//  旅游季
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItinerarieModel;

@protocol NearSectionClickDelegate <NSObject>
- (void)selectSectionAction:(id )sectionView;

@end

@interface NearSectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) id<NearSectionClickDelegate> delegate;

@property (strong, nonatomic) ItinerarieModel *itinerarieModel;
@property (assign, nonatomic) CGFloat sectionHeaderH;
@property (assign, nonatomic) NSInteger sectiontIndex;
@end
