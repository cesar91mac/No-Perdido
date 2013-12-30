//
//  LogInViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"

@interface LogInViewController : UIViewController<OwnerProtocol>


@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)logInButtonPressed:(id)sender;

- (IBAction)nextTextField:(id)sender;

- (IBAction)recoverPassword:(id)sender;

@end
