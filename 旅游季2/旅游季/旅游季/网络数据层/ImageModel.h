//
//  ImageModel.h
//  旅游季
//
//  Created by niit on 16/1/27.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
typedef void (^CompleteRequestImage) (id result);
@interface ImageModel : NSObject

@property (strong, nonatomic) NSData *imagedata;
@property (assign, nonatomic) CGFloat image_H;
@property (assign, nonatomic) CGFloat image_W;
@property (strong, nonatomic) NSString *imageUrl;

+(void)requestImageDataWithMessageId:(NSString *)messageId result:(CompleteRequestImage)result;

@end
