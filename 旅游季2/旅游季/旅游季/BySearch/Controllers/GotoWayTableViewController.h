//
//  GotoWayTableViewController.h
//  旅游季
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class BMKPoiInfo;
@protocol  GotoWayDelegate <NSObject>
- (void)gotoWayByBMKPoiInfo:(CLLocationCoordinate2D)destinationPoint;
@end
@interface GotoWayTableViewController : UITableViewController

@property (weak, nonatomic) id <GotoWayDelegate>findWaydelegate;
@property (strong, nonatomic) NSArray *destinationPoint;

@end
