//
//  UbicarViewController.h
//  No+Perdido
//
//  Created by César Flores on 12/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Pet;

@protocol LocatePetProtocol <NSObject>

-(void)locatePet:(Pet*)pet InViewController:(UIViewController*)viewController;

@end


@interface LocateViewController : UIViewController <LocatePetProtocol>

@property (strong, nonatomic) IBOutlet MKMapView *locatePetMapView;

@end
