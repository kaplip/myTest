//
//  ImageModel.m
//  旅游季
//
//  Created by niit on 16/1/27.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

+(void)requestImageDataWithMessageId:(NSString *)messageId result:(CompleteRequestImage)result{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"ImageAuthor"];
    [bquery whereKey:@"Message" equalTo:messageId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array) {
            NSMutableArray *imageArrM = [[NSMutableArray alloc]initWithCapacity:array.count];
            for (BmobObject *imageB in array) {
                ImageModel *imageModel = [[ImageModel alloc]initWithBmobobject:imageB];
                [imageArrM addObject:imageModel];
              
            }
            result([imageArrM copy]);
        }
    }];
}

- (instancetype)initWithBmobobject:(BmobObject *)b{
    
    if (self = [super init]) {
        _imageUrl = [b objectForKey:@"url"];
        _image_W = [[b objectForKey:@"image_W"] floatValue];
        _image_H = [[b objectForKey:@"image_H"] floatValue];
        
    }
    return self;
    
}

@end
