//
//  BBMRootViewController.h
//  berkeleyBikeMap
//
//  Created by David on 10/24/12.
//  Copyright (c) 2012 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"

typedef unsigned int BBMLocationButtonState;

enum BBMLocationButtonState {
    kBBMLocationButtonNotSelected = 0,
    kBBMLocationButtonSelected = 1,
    kBBMLocationButtonSelectedHeading =2
    };

@interface BBMRootViewController : UIViewController <RMMapViewDelegate>

@property (nonatomic,strong) RMMapView * mapView;
@property (nonatomic,strong) UIButton * locationButton;
@property (nonatomic) BBMLocationButtonState locationButtonState;


-(void)locationButtonSelected;

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;

@end
