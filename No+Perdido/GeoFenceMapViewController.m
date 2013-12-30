//
//  GeoFenceMapViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/16/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "GeoFenceMapViewController.h"


@interface GeoFenceMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation GeoFenceMapViewController{
    
    Annotation *annotationPoint1, *annotationPoint2;

}

- (void)viewDidLoad{
    
    [super viewDidLoad];
	
    
    if (!self.annotationArray) {
    
        self.annotationArray = [[NSMutableArray alloc] init];
        
    }
    
    UILongPressGestureRecognizer *longPressGesuture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setPinInMapView:)];
    
    longPressGesuture.minimumPressDuration = 1.0;
    
    [self.GeoFenceMap addGestureRecognizer:longPressGesuture];
    
    
   /* UILongPressGestureRecognizer *removePinsLongPresGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removePins:)];

    removePinsLongPresGesture.minimumPressDuration = 2.0;
    
    removePinsLongPresGesture.numberOfTouchesRequired = 2;
    
    [self.GeoFenceMap addGestureRecognizer:removePinsLongPresGesture];*/
    
    
    self.GeoFenceMap.showsUserLocation = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    self.GeoFenceMap.delegate = self;
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreat
}

- (IBAction)leftButtonTapped:(id)sender {
        
    [self.delegate geofenceCanceledInViewController:self];
    
}

- (IBAction)rightButtonTapped:(id)sender {

    [self.delegate geofenceSavedWithCoordinate:annotationPoint1.coordinate AndCoordinate2:annotationPoint2.coordinate InViewController:self];

    
}



#pragma mark Map Interaction

-(void)setPinInMapView:(UILongPressGestureRecognizer*)longPress{
    
    
    if (self.annotationArray.count == 0) {
        
        NSLog(@"El arreglo está vacío");
        
        annotationPoint1 = [[Annotation alloc] init];
        
        CGPoint pressPoint = [longPress locationInView:self.GeoFenceMap];
        
        annotationPoint1.coordinate = [self.GeoFenceMap convertPoint:pressPoint toCoordinateFromView:self.GeoFenceMap];
        
        annotationPoint1.title = @"Punto 1";
        
        annotationPoint1.subtitle = @"Se trazará un área cuadrada a partir de este punto.";
        
        [self.annotationArray addObject:annotationPoint1];
        
    }else if (self.annotationArray.count == 1) {
        
        
        annotationPoint2 = [[Annotation alloc] init];
        
        CGPoint pressPoint = [longPress locationInView:self.GeoFenceMap];
        
        annotationPoint2.coordinate = [self.GeoFenceMap convertPoint:pressPoint toCoordinateFromView:self.GeoFenceMap];
        
        //NSLog(@"latitude %f longitude %f",annotationPoint2.coordinate.latitude,annotationPoint2.coordinate.longitude);
        
        annotationPoint2.title = @"Punto 2";
        
        annotationPoint2.subtitle = @"Se trazará un área cuadrada a partir de este punto.";
        
        if (annotationPoint1.coordinate.longitude != annotationPoint2.coordinate.longitude) {
       
             [self.annotationArray addObject:annotationPoint2];
            
        }
        
    }

    [self.GeoFenceMap addAnnotations:self.annotationArray];

    if (self.annotationArray.count == 2) {
    
        
        [self drawGeofence];
        
    }
}

-(void)removePins:(UILongPressGestureRecognizer*)longPressGR{
    
    NSLog(@"Se eliminan");
}



#pragma mark MKOverlayView Delegate

-(void)drawGeofence{
    
    CLLocationCoordinate2D coordinates[5];
    
    annotationPoint1 = [self.annotationArray objectAtIndex:0];
    
    annotationPoint2 = [self.annotationArray objectAtIndex:1];
    
    coordinates[0] = annotationPoint1.coordinate;
    
    coordinates[1] = CLLocationCoordinate2DMake(annotationPoint2.coordinate.latitude, annotationPoint1.coordinate.longitude);
    
    coordinates[2] = annotationPoint2.coordinate;
    
    coordinates[3] = CLLocationCoordinate2DMake(annotationPoint1.coordinate.latitude, annotationPoint2.coordinate.longitude);
    
    coordinates[4] = coordinates[0];
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:5];
    
    [self.GeoFenceMap addOverlay:polyLine];

}

/*- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    polylineView.strokeColor = [UIColor blueColor];
    
    polylineView.lineWidth = 1.5;
    
    return polylineView;
}*/


-(MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    polylineView.strokeColor = [UIColor blueColor];
    
    polylineView.lineWidth = 1.5;
    
    return polylineView;
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (self.annotationArray.count > 0) {
        
        [self setPinInMapView:Nil];
        
        Annotation *focusAnnotation1 = [self.annotationArray objectAtIndex:0];
        
        Annotation *focusAnnotation2 = [self.annotationArray objectAtIndex:1];
        
        CLLocationCoordinate2D focusToPoint = CLLocationCoordinate2DMake((focusAnnotation1.coordinate.latitude+focusAnnotation2.coordinate.latitude)/2, (focusAnnotation1.coordinate.longitude + focusAnnotation2.coordinate.longitude)/2);
        
        [self.GeoFenceMap setRegion:MKCoordinateRegionMakeWithDistance(focusToPoint, 1000, 1000) animated:YES];
        
    }else{
        
        CLLocationCoordinate2D userLocations;
        
        userLocations.latitude  = self.locationManager.location.coordinate.latitude;
        
        userLocations.longitude = self.locationManager.location.coordinate.longitude;
        
        [self.GeoFenceMap setRegion:MKCoordinateRegionMakeWithDistance(userLocations, 1000, 1000) animated:YES];
        
    }
    
}

@end
