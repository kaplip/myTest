//
//  ZYMFlowLayout.h
//  瀑布流实现方法测试
//
//  Created by niit on 16/1/26.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat width);
@interface ZYMFlowLayout : UICollectionViewLayout
/** 列数 */
 @property (nonatomic, assign) NSInteger lineNumber;
 /** 行间距 */
 @property (nonatomic, assign) CGFloat rowSpacing;
 /** 列间距 */
 @property (nonatomic, assign) CGFloat lineSpacing;
 /** 内边距 */
  @property (nonatomic, assign) UIEdgeInsets sectionInset;

- (void)computerIndexCellHeightWithWidthBlock:(CGFloat (^)(NSIndexPath *indexpath, CGFloat width))block;
@end
