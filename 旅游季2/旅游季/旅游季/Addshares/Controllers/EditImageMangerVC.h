//
//  EditImageMangerVC.h
//  旅游季
//
//  Created by niit on 16/1/21.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditImageActionDelegate <NSObject>

- (void)compeletChangeImage:(UIImage *)resultImage;

@end

@interface EditImageMangerVC : UIViewController

@property (strong, nonatomic) UIImage *sourceImage;
@property (weak, nonatomic) id <EditImageActionDelegate> changeImagedelegate;

@end
