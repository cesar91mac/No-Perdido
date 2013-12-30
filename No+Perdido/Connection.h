//
//  Connection.h
//  XMLParser
//
//  Created by Mauricio on 12/11/13.
//  Copyright (c) 2013 Mauricio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject

-(BOOL) response:(int)action parameters:(NSMutableDictionary*) array;

@property (nonatomic,strong) NSString* APIResult;
@property (nonatomic,strong) NSMutableDictionary* JSONResult;

@end
