//
//  NSString+NsstringTool.m
//  旅游季
//
//  Created by niit on 16/1/17.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "NSString+NsstringTool.h"

@implementation NSString (NsstringTool)

- (CGRect)setStrRectWithStr:(NSString *)str font:(UIFont *)font sourceSize:(CGSize)sourceSize{
    CGRect strRect;
    
        strRect = [str boundingRectWithSize:sourceSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil];
  
    return strRect;
    
}

@end
