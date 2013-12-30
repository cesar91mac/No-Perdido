//
//  Pet.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/14/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "Pet.h"

@implementation Pet




- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.simNumber forKey:@"simNumber"];
    [encoder encodeBool:self.panic forKey:@"panic"];
    [encoder encodeBool:self.status forKey:@"status"];
    [encoder encodeBool:self.geofenceActivated forKey:@"geofenceActivated"];
    [encoder encodeObject:self.geofencePoints forKey:@"geofencePoints"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        
        self.name = [decoder decodeObjectForKey:@"name"];
        self.simNumber = [decoder decodeObjectForKey:@"simNumber"];
        self.panic = [decoder decodeBoolForKey:@"panic"];
        self.status = [decoder decodeBoolForKey:@"status"];
        self.geofenceActivated = [decoder decodeBoolForKey:@"geofenceActivated"];
        self.geofencePoints = [decoder decodeObjectForKey:@"geofencePoints"];
        
        
    }
    return self;
}
@end
