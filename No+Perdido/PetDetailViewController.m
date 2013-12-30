//
//  PetDetailViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/16/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "PetDetailViewController.h"
#import "NewPetViewController.h"
#import "PersistentStorageAssitant.h"
#import "Connection.h"

@interface PetDetailViewController ()

@end

@implementation PetDetailViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //NSLog(@"viewwillappear");
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PetCell";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0 ) {
        
       cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

   
         if (!cell) {
             
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
             
         }

        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Nombre:";
                cell.detailTextLabel.text = self.selectedPet.name;
                break;
            case 1:
                cell.textLabel.text = @"SIM:";
                cell.detailTextLabel.text = self.selectedPet.simNumber;
                break;
            default:
                break;
        }
    
    
    
    
    }else if(indexPath.section == 1){
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
        
        
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"SwitchCell"];

        }
        
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"GeoFence";
                
                if (self.selectedPet.geofenceActivated){
                    
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                }else{
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
        
                break;
            case 1:
                cell.textLabel.text = @"Panic";
                
                if (self.selectedPet.panic){
                    
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    
                }else{
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                break;
            default:
                break;
        }
    }

    return cell;
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *header;
    
    switch (section) {
        case 0:
            header = @"Información General";
            break;
        case 1:
            header = @"Alertas";
            break;
        default:
            break;
    }
    
    return header;
    
}

#pragma mark - Pet Update Protocol

-(void)savePet:(Pet *)pet UpdateInViewController:(UIViewController *)viewController{

    int index = [self.petMasterViewController.thePetList indexOfObject:self.selectedPet];

    [self.petMasterViewController.thePetList removeObjectAtIndex:index];
    
    [self.petMasterViewController.thePetList insertObject:pet atIndex:index];
    
    self.selectedPet = pet;
    
    [PersistentStorageAssitant saveArray:self.petMasterViewController.thePetList InDocumentsFolderToFileWithName:@"PetList.plist"];
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)cancelUpdateInViewController:(UIViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)deletePet:(Pet *)pet{
    
    NSLog(@"borrando");
    
    //Hace la petición al servidor
    
    Connection *myCon = [[Connection alloc]init];
    NSData *encodedOwner = [[NSUserDefaults standardUserDefaults] objectForKey:@"credentials"];
    Owner *userInfo = (Owner *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userInfo.email,@"email",pet.simNumber,@"phone", nil];
    
    [myCon response:6 parameters:param];
    
    
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
            {
                [self.petMasterViewController.thePetList removeObject:pet];
                
                [PersistentStorageAssitant saveArray:self.petMasterViewController.thePetList InDocumentsFolderToFileWithName:@"PetList.plist"];

                [self dismissViewControllerAnimated:YES completion:nil];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        });
    });
}

-(BOOL) validate:(NSString*)res
{
    NSLog(@"APIResult = [%@]",res);
    
    NSString *title = @"0";
    NSString *message;
    
    if([res isEqualToString:@"ERROR"])
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"EditPet"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        NewPetViewController *newPetViewController = (NewPetViewController*)[navigationController.viewControllers lastObject];
        
        newPetViewController.petDelegate = self;
        
        newPetViewController.pet = self.selectedPet;
        
    }
}



@end
