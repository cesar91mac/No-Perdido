//
//  Annotation.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/27/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>


@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;


@end
