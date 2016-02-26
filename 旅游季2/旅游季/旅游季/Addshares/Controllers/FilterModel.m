//
//  FilterModel.m
//  旅游季
//
//  Created by niit on 16/1/23.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel
- (void)setFilterWithTag:(NSInteger)tag{
    
    CIFilter *filter;
    
    switch (tag) {
        case 0:
            filter = [CIFilter filterWithName:@"CIColorControls"];
            _filterName = @"CIColorControls";
            _filterAttributeName = @"inputBrightness";
            break;
        case 1:
            filter = [CIFilter filterWithName:@"CIColorControls"];
            _filterName = @"CIColorControls";
            _filterAttributeName = @"inputContrast";
            break;
        case 2:
            filter = [CIFilter filterWithName:@"CIColorControls"];
            _filterName = @"CIColorControls";
            _filterAttributeName = @"inputSaturation";
            break;
        case 3:
            filter = [CIFilter filterWithName:@"CIVibrance"];
            _filterName = @"CIVibrance";
            _filterAttributeName = @"inputAmount";
            break;
        case 4:
            filter = [CIFilter filterWithName:@"CIExposureAdjust"];
            _filterName = @"CIExposureAdjust";
            _filterAttributeName = @"inputEV";
            break;
        default:
            break;
    }
 
    _filter = filter;
}
@end
