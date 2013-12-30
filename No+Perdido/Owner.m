//
//  Owner.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "Owner.h"

@implementation Owner


- (void)encodeWithCoder:(NSCoder *)encoder {
  
    [encoder encodeObject:self.name forKey:@"name"];
    
    [encoder encodeObject:self.lastName forKey:@"lastname"];
    
    [encoder encodeObject:self.email forKey:@"email"];
    
    [encoder encodeObject:self.password forKey:@"password"];
    
    [encoder encodeObject:self.phoneArray forKey:@"phoneArray"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
    
        self.name = [decoder decodeObjectForKey:@"name"];
        
        self.lastName = [decoder decodeObjectForKey:@"lastname"];
        
        self.email = [decoder decodeObjectForKey:@"email"];
        
        self.password = [decoder decodeObjectForKey:@"password"];
        
        self.phoneArray = [decoder decodeObjectForKey:@"phoneArray"];
    }
    return self;
}


@end
