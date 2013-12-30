//
//  GeoFenceMapViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/16/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@protocol GeofenceProtocol <NSObject>

-(void)geofenceSavedWithCoordinate:(CLLocationCoordinate2D)coordinate1  AndCoordinate2:(CLLocationCoordinate2D)coordinate2 InViewController:(UIViewController*)viewController;

-(void)geofenceCanceledInViewController:(UIViewController*)viewController;


@end

@interface GeoFenceMapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>



- (IBAction)leftButtonTapped:(id)sender;

- (IBAction)rightButtonTapped:(id)sender;


@property (nonatomic, strong) NSMutableArray *annotationArray;

@property (nonatomic, strong) id <GeofenceProtocol> delegate;

@property (strong, nonatomic) IBOutlet MKMapView *GeoFenceMap;


@end
