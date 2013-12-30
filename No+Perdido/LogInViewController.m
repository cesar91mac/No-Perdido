//
//  LogInViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "Owner.h"
#import "PersistentStorageAssitant.h"
#import "Connection.h"
#import "Pet.h"
#import "AppDelegate.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"credentials"])
        [self performSegueWithIdentifier:@"LogIn" sender:nil];

    self.errorLabel.alpha = 0.0;
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonPressed:(id)sender {
    
    
    [self.password resignFirstResponder];
    
    [self.username resignFirstResponder];
    
    if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""])
    {
        Connection *myCon = [[Connection alloc]init];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.username.text,@"email",self.password.text,@"password", nil];
        
        [myCon response:1 parameters:param];
        
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        
        activity.center = self.view.center;
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        [activity startAnimating];
        [self.view addSubview:activity];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            
            ((AppDelegate *)[UIApplication sharedApplication].delegate).logIn = TRUE;
            
            while ([myCon.APIResult isEqualToString:@"NOYET"])
            {            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [activity stopAnimating];
                
                [self validate:myCon.APIResult userData:myCon.JSONResult];
            });
        });
        
    }else{
        
        NSLog(@"No existe -");
        
        [self flickerView:self.errorLabel withError:1];
        
    }
    
}


-(void) validate:(NSString*)res userData:(NSMutableDictionary*)jsonObject
{
    NSLog(@"APIResult = [%@]",res);
    
    if([res isEqualToString:@"-1"])
    {
        [self flickerView:self.errorLabel withError:1];
    }
    else if([res isEqualToString:@"ERROR"])
    {
        [self flickerView:self.errorLabel withError:2];
    }
    else if([res isEqualToString:@"0"])
    {
        [self flickerView:self.errorLabel withError:3];
    }
    else
    {
        NSLog(@"Deserialized JSON Dictionary = %@",jsonObject);
        
        Owner *user = [[Owner alloc] init];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithDictionary:[jsonObject objectForKey:@"user"]];
        
        user.name = [userData objectForKey:@"firstname"];
        user.lastName = [userData objectForKey:@"lastname"];
        user.email = self.username.text;
        user.password = self.password.text;
        user.phoneArray = [userData objectForKey:@"phones"];
        
        [PersistentStorageAssitant saveCustomOwner:user ToUserDefaultsWithKey:@"credentials"];
        
        NSMutableArray *petsArray = [NSMutableArray array];
        
        for (NSDictionary *dict in [jsonObject objectForKey:@"pets"])
        {
            Pet *pet =[[Pet alloc] init];
            
            pet.name = [dict objectForKey:@"petname"];
            pet.simNumber = [dict objectForKey:@"idpet"];
            pet.status = ([[dict objectForKey:@"status"] isEqualToString:@"1"] ? true : false);
            
            [petsArray addObject:pet];
        }
        
        [PersistentStorageAssitant saveArray:petsArray InDocumentsFolderToFileWithName:@"PetList.plist"];
        
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
    }
}

-(void)flickerView:(UIView*)theFlickeringView withError:(int)error{
    
    if(error == 2)
        self.errorLabel.text = @"No hay conexión";
    
    if(error == 3)
        self.errorLabel.text = @"Error de conexión";
    
    if (theFlickeringView.alpha == 0.0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            theFlickeringView.alpha = 1.0;
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.1 animations:^{
            
            theFlickeringView.alpha = 0.0;
            
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                theFlickeringView.alpha = 1.0;
            }];
            
        }];
    }
}


- (IBAction)nextTextField:(id)sender {
    
    [self.password becomeFirstResponder];
}

- (IBAction)recoverPassword:(id)sender {
    
    [self performSegueWithIdentifier:@"Recovery" sender:nil];
}


#pragma mark Owner Protocol

-(void)saveOwner:(Owner *)owner ProfileUpdateInViewController:(UIViewController *)viewController{
    
    [PersistentStorageAssitant saveCustomOwner:owner ToUserDefaultsWithKey:@"credentials"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self performSegueWithIdentifier:@"LogIn" sender:nil];
}

-(void)cancelOwnerProfileUpdateInViewController:(UIViewController *)viewController{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"Signup"]) {
    
        UINavigationController *navigationController = segue.destinationViewController;
        
        SignUpViewController *signupViewController = (SignUpViewController*)[navigationController.viewControllers lastObject];
        
        signupViewController.delegate = self;
        
    }
}

@end
