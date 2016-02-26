//
//  MessageDetailFootView.h
//  旅游季
//
//  Created by niit on 16/2/16.
//  Copyright © 2016年 niit. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol sendCritiqueDelegate <NSObject>

- (void)sendCritiqueAction:(NSString *)content;

@end

@interface MessageDetailFootView : UIView

@property (weak, nonatomic) id<sendCritiqueDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
@end
