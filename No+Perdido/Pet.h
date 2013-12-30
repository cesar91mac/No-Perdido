//
//  Pet.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/14/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Pet;

@protocol PetUpdateProtocol <NSObject>

-(void)savePet:(Pet*)pet UpdateInViewController:(UIViewController*)viewController;

-(void)cancelUpdateInViewController:(UIViewController*)viewController;

-(void)deletePet:(Pet*)pet;

@end

@interface Pet : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *simNumber;

@property (nonatomic, assign) BOOL panic;
@property (nonatomic, assign) BOOL geofenceActivated;
@property (nonatomic, assign) BOOL status; //activated
//@property (nonatomic, assign) double centerLatitude;
//@property (nonatomic, assign) double centerLongitude;

@property (nonatomic, strong) NSMutableDictionary *geofencePoints;





@end
