//
//  UserProfileViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "OwnerProfileViewController.h"
#import "Owner.h"
#import "LogInViewController.h"
#import "PersistentStorageAssitant.h"
@interface OwnerProfileViewController ()

@end

@implementation OwnerProfileViewController{
    
    Owner *currentOwner;
    
    UITextField *password;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    currentOwner = [PersistentStorageAssitant getCustomOwnerFromUserDefaultsWithKey:@"credentials"];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(112, 2, 180, 40)];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark User Interaction
- (IBAction)editButtonTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"EditOwner" sender:nil];
    
}

- (IBAction)logOutButtonTapped:(id)sender {
    
    LogInViewController *logInViewController = [[self storyboard] instantiateInitialViewController];
    
    [PersistentStorageAssitant removeCustomOwnerFromUserDefaultsWithKey:@"credentials"];
    
    [PersistentStorageAssitant deletePetArrayFromDocumentsFolderInFile:@"PetList.plist"];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PetList.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSLog(@"Se borró");
    }
    
    [self presentViewController:logInViewController animated:NO completion:nil];
    
}


#pragma mark TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 2) {
        
        return currentOwner.phoneArray.count;
    }
    
    return 2;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ProfileCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Nombre";
                cell.detailTextLabel.text = currentOwner.name;
                break;
            case 1:
                cell.textLabel.text = @"Apellido";
                cell.detailTextLabel.text = currentOwner.lastName;
                break;
        }
    
    }else if (indexPath.section == 1 ){
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"E-mail";
                cell.detailTextLabel.text = currentOwner.email;
                break;
            case 1:
                cell.textLabel.text = @"Contraseña";
                cell.detailTextLabel.hidden = YES;
                [password removeFromSuperview];
                password.secureTextEntry = YES;
                password.enabled = NO;
                password.text = currentOwner.password;
                [cell addSubview:password];
                break;
        }
    
    }else if (indexPath.section == 2){
        
        cell.textLabel.text = [NSString stringWithFormat:@"Teléfono %d",indexPath.row+1];
        
        cell.detailTextLabel.text = [currentOwner.phoneArray objectAtIndex:indexPath.row];
    }
    
    
    return cell;
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"Datos Generales";
            break;
        case 1:
            title = @"Credencial";
            break;
        case 2:
            title = @"Teléfonos Autorizados";
            break;
        default:
            break;
    }
    
    return title;
}

#pragma mark Owner Protocol

-(void)saveOwner:(Owner *)owner ProfileUpdateInViewController:(UIViewController *)viewController{
    
    [PersistentStorageAssitant saveCustomOwner:owner ToUserDefaultsWithKey:@"credentials"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)cancelOwnerProfileUpdateInViewController:(UIViewController *)viewController{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"EditOwner"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        OwnerProfileUpdateViewController *ownerUpdateViewController = (OwnerProfileUpdateViewController*)[navigationController.viewControllers lastObject];
        
        ownerUpdateViewController.delegate = self;
        
        ownerUpdateViewController.editedOwner = currentOwner;
    }
}

@end
