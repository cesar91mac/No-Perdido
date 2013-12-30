//
//  InputValidator.m
//  No+Perdido
//
//  Created by César Flores on 11/13/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "InputValidator.h"

@implementation InputValidator




+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern{
    
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;
    
    return didValidate;
}


@end
