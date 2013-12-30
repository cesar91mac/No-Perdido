//
//  SignUpViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "SignUpViewController.h"
#import "Owner.h"
#import "InputValidator.h"
#import "Connection.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController



- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self emptyStringValidator];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideKeyboard:(id)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(id)sender {
    
    [self.delegate cancelOwnerProfileUpdateInViewController:self];
}

- (IBAction)signupButtonTapped:(id)sender {

    if ([self emptyStringValidator]) {
        
        
        [self.nameTextField resignFirstResponder];
        [self.lastNameTextField resignFirstResponder];
        [self.phoneTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        [self.password2TextField resignFirstResponder];
        
        NSString *phoneRegex = @"^[2-9][0-9]{9}$";
        
        NSString *emailRegex = @"^([^(\\.|\\-|_)])((?:[a-z]|[0-9]|\\.|-|_)+)@([a-z]{2,})\\.([\\S]+)";
        
        
        BOOL phoneValidates = [InputValidator validateString:self.phoneTextField.text withPattern:phoneRegex];
        
        BOOL mailValidates = [InputValidator validateString:self.emailTextField.text withPattern:emailRegex];
        
        
        if (phoneValidates) {
            
            
            if (mailValidates) {
                
                
                if ([self.passwordTextField.text isEqualToString:self.password2TextField.text])
                {
                    Owner *newOwner = [[Owner alloc] init];
                    
                    newOwner.name = self.nameTextField.text;
                    
                    newOwner.lastName = self.lastNameTextField.text;
                    
                    newOwner.phoneArray = [[NSMutableArray alloc] init];
                    
                    [newOwner.phoneArray addObject: self.phoneTextField.text];
                    [newOwner.phoneArray addObject: @""];
                    [newOwner.phoneArray addObject: @""];
                    [newOwner.phoneArray addObject: @""];
                    [newOwner.phoneArray addObject: @""];
                    
                    NSLog(@"tamaño array = %lld",(long long)newOwner.phoneArray.count);
                    
                    newOwner.email = self.emailTextField.text;
                    
                    newOwner.password = self.passwordTextField.text;
                    
                    
                    //Hace la petición al servidor
                    
                    Connection *myCon = [[Connection alloc]init];
                    
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.emailTextField.text,@"email",self.passwordTextField.text,@"password",self.nameTextField.text,@"firstname",self.lastNameTextField.text,@"lastname",self.phoneTextField.text,@"phone1", nil];
                    
                    [myCon response:2 parameters:param];
                    
                    
                    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
                    
                    activity.center = self.view.center;
                    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                    
                    [activity startAnimating];
                    [self.view addSubview:activity];
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        
                        while ([myCon.APIResult isEqualToString:@"NOYET"])
                        {            }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [activity stopAnimating];
                            
                            if([self validate:myCon.APIResult])
                                [self.delegate saveOwner:newOwner ProfileUpdateInViewController:self];
                        });
                    });
                    
                }
                else
                {
                    
                    UIAlertView *invalidPassword = [[UIAlertView alloc] initWithTitle:@"Contraseñas No Coinciden" message:@"Reintroduzca las contraseñas." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    self.passwordTextField.text = @"";
                    
                    self.password2TextField.text = @"";
                    
                    [invalidPassword show];
                    
                }
                
                
            }else{
                
                UIAlertView *invalidEmailAlert = [[UIAlertView alloc] initWithTitle:@"Correo Inválido" message:@"El formato del correo no es válido." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                
                [invalidEmailAlert show];
            }
            
            
        }else{
            
            UIAlertView *invalidPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Teléfono Inválido" message:@"El formato del teléfono no es válido." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [invalidPhoneAlert show];
        
        }
        
     
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campos vacíos" message:@"Todos los campos son obligatorios" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(BOOL) validate:(NSString*)res
{
    NSLog(@"APIResult = [%@]",res);
    
    NSString *title = @"0";
    NSString *message;
    
    if([res isEqualToString:@"-1"])
    {
        title = @"Email inválido";
        message = [NSString stringWithFormat: @"Ya existe una cuenta registrada con el correo %@.\nPor favor intenta nuevamente.",self.emailTextField.text];
    }
    else if([res isEqualToString:@"ERROR"])
    {
        title = @"Error de conexión";
        message = [NSString stringWithFormat: @"No hay conexión a internet.\nPor favor intenta nuevamente."];
    }
    else if(![res isEqualToString:@"0"])
    {
        title = @"Error interno";
        message = [NSString stringWithFormat: @"Hubo un error al realizar tu registro.\nPor favor intenta nuevamente."];
    }
    
    if(![title isEqualToString:@"0"])
    {
        UIAlertView *showError = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [showError show];
        
        return NO;
    }
    
    return YES;
}


-(BOOL)emptyStringValidator{
    
    UITableViewCell *cell;
    
    UITextField *textField;

    for (int i = 0; i < 7; i++) {
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    
        textField = (UITextField*)[cell viewWithTag:21];
        
        if ([textField.text isEqualToString:@""]) {
            
            return NO;
        }
    }

    
    return YES;
}

@end
