//
//  InputValidator.h
//  No+Perdido
//
//  Created by César Flores on 11/13/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputValidator : NSObject



+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern;

@end
