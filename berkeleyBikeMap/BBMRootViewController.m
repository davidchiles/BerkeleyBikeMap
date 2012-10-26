//
//  BBMRootViewController.m
//  berkeleyBikeMap
//
//  Created by David on 10/24/12.
//  Copyright (c) 2012 David. All rights reserved.
//

#import "BBMRootViewController.h"
#import "RMMBTilesSource.h"
#import "RMUserTrackingBarButtonItem.h"
#import "RMUserLocation.h"
#import <QuartzCore/QuartzCore.h>


@interface BBMRootViewController ()

@end

@implementation BBMRootViewController

@synthesize mapView;
@synthesize locationButton;
@synthesize locationButtonState;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setupLocationButton
{
    //User Heading Button states images
    UIImage *buttonImage = [UIImage imageNamed:@"greyButtonHighlight.png"];
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"greyButton.png"];
    UIImage *buttonArrow = [UIImage imageNamed:@"TrackingLocation.png"];
    
    //Configure the button
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton addTarget:self action:@selector(locationButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    //Add state images
    [locationButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [locationButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [locationButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [locationButton setImage:buttonArrow forState:UIControlStateNormal];
    
    //Button shadow
    locationButton.frame = CGRectMake(5,425,39,30);
    locationButton.layer.cornerRadius = 8.0f;
    locationButton.layer.masksToBounds = NO;
    locationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    locationButton.layer.shadowOpacity = 0.8;
    locationButton.layer.shadowRadius = 1;
    locationButton.layer.shadowOffset = CGSizeMake(0, 1.0f);
    
    [self.mapView addSubview:locationButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(37.869094,-122.271223);
    CLLocationCoordinate2D southWestConstraint = CLLocationCoordinate2DMake(37.8473,-122.3306);
    CLLocationCoordinate2D northEastConstraint = CLLocationCoordinate2DMake(37.8887,-122.2055);
	
    RMMBTilesSource * tileSource = [[RMMBTilesSource alloc] initWithTileSetURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"berkeley" ofType:@"mbtiles"]]];
    mapView = [[RMMapView alloc] initWithFrame:self.view.frame andTilesource:tileSource centerCoordinate:center zoomLevel:16 maxZoomLevel:18 minZoomLevel:14 backgroundImage:nil];
    [self.mapView setConstraintsSouthWest:southWestConstraint northEast:northEastConstraint];
    mapView.delegate = self;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //mapView.adjustTilesForRetinaDisplay = YES;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        mapView.contentScaleFactor = 2.0;
    }
    else {
        mapView.contentScaleFactor = 1.0;
    }
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    
    
    [self setupLocationButton];
    locationButtonState = kBBMLocationButtonNotSelected;
    
    
    //RMUserTrackingBarButtonItem * locationBarButton = [[RMUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    
    //self.toolbarItems = [NSArray arrayWithObjects:locationBarButton, nil];
    
}

-(void) locationButtonSelected
{
    //Currently tracking or not traacking
    if(self.locationButtonState == kBBMLocationButtonNotSelected)
    {
        [self.mapView setUserTrackingMode:RMUserTrackingModeFollow animated:YES];
        self.locationButtonState = kBBMLocationButtonSelected;
        UIImage *buttonArrow = [BBMRootViewController imageNamed:@"TrackingLocation.png" withColor:[UIColor blueColor]];
        [locationButton setImage:buttonArrow forState:UIControlStateNormal];
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    }
    else if(self.locationButtonState == kBBMLocationButtonSelected)
    {
        self.locationButtonState = kBBMLocationButtonSelectedHeading;
        [self.mapView setUserTrackingMode:RMUserTrackingModeFollowWithHeading animated:YES];
        UIImage *buttonArrow = [BBMRootViewController imageNamed:@"TrackingHeading.png" withColor:[UIColor blueColor]];
        [locationButton setImage:buttonArrow forState:UIControlStateNormal];
    }
    else
    {
        UIImage *buttonArrow = [UIImage imageNamed:@"TrackingLocation.png"];
        [self.mapView setUserTrackingMode:RMUserTrackingModeFollow animated:YES];
        [locationButton setImage:buttonArrow forState:UIControlStateNormal];
        self.locationButtonState = kBBMLocationButtonNotSelected;
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    mapView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color
{
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
    
}


#pragma mapViewDelegate

-(void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    if(wasUserAction && self.locationButtonState == kBBMLocationButtonSelectedHeading)
    {
        UIImage *buttonArrow = [UIImage imageNamed:@"TrackingLocation.png"];
        [locationButton setImage:buttonArrow forState:UIControlStateNormal];
        self.locationButtonState = kBBMLocationButtonNotSelected;
    }
}
@end
