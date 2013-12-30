//
//  SignUpViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"

@interface SignUpViewController : UITableViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *password2TextField;

@property  (nonatomic, strong) id <OwnerProtocol> delegate;


- (IBAction)hideKeyboard:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)signupButtonTapped:(id)sender;


@end
