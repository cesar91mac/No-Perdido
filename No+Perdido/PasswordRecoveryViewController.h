//
//  PasswordRecoveryViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordRecoveryViewController : UIViewController
- (IBAction)sendButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)hideKeyboard:(id)sender;

@end
