//
//  Owner.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Owner;

@protocol OwnerProtocol <NSObject>

-(void)saveOwner:(Owner*)owner ProfileUpdateInViewController:(UIViewController*)viewController;

-(void)cancelOwnerProfileUpdateInViewController:(UIViewController*)viewController;

@end

@interface Owner : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;


@property (nonatomic, strong) NSMutableArray *phoneArray;

@end
