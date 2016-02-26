//
//  MessageDetaileHeader.h
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareModel;

@protocol EndEditDelegate <NSObject>

- (void)endEditingAction;
- (void)commitAction;

@end



@interface MessageDetaileHeader : UIView
@property (weak, nonatomic) id<EndEditDelegate> delegate;
- (instancetype)initWithShareModel:(ShareModel *)shareModel;

@end
