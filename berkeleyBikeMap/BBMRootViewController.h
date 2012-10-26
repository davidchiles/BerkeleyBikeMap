//
//  BBMRootViewController.h
//  berkeleyBikeMap
//
//  Created by David on 10/24/12.
//  Copyright (c) 2012 David. All rights reserved.
//
//  This file is part of BerkeleyBikeMap.
//
//  BerkeleyBikeMap is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  POI+ is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with BerkeleyBikeMap.  If not, see <http://www.gnu.org/licenses/>.

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
