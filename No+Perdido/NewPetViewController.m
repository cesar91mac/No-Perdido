//
//  NewPetViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/16/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "NewPetViewController.h"
#import "Pet.h"
#import "InputValidator.h"
#import "Connection.h"
#import "Owner.h"

@interface NewPetViewController ()

@end

@implementation NewPetViewController{
    
    int numberOfRows;
    
    NSMutableArray *newPetArray;
    
    BOOL editingMode;
    
    NSString *simAnterior;
}



- (void)viewDidLoad{

    [super viewDidLoad];
    
    NSLog(@"Aqui está");
    
    editingMode = NO;
    
    if (self.pet)
    {
        simAnterior = self.pet.simNumber;
        NSLog(@"Anterior %@",simAnterior);
        editingMode = YES;
    }
    else self.pet = [[Pet alloc] init];
    
}




#pragma mark User Interaction

- (IBAction)saveNewPet:(id)sender {
    
    if ([self validateEmptyInput]) {
        
        if ([self assignDataToPet:self.pet InTableViewSection:0]) {
            
            if (editingMode)
            {
                //Hace la petición al servidor
                
                Connection *myCon = [[Connection alloc]init];
                
                NSData *encodedOwner = [[NSUserDefaults standardUserDefaults] objectForKey:@"credentials"];
                Owner *userInfo = (Owner *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];
                
                
                NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userInfo.email,@"email",self.pet.name,@"petname",self.pet.simNumber,@"new_phone", simAnterior,@"phone", nil];
                
                [myCon response:7 parameters:param];
                
                NSLog(@"actualziando mascota");
                
                UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
                activity.frame = CGRectMake(150, 100, 20, 20);
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
                            [self assignToPet:self.pet SwitchValuesInRow:0 AndSection:1];
                            [self assignToPet:self.pet SwitchValuesInRow:1 AndSection:1];
                            [self.petDelegate savePet:self.pet UpdateInViewController:self];
                        }
                    });
                });
            }
            else
            {
                //Hace la petición al servidor
                
                Connection *myCon = [[Connection alloc]init];
                NSData *encodedOwner = [[NSUserDefaults standardUserDefaults] objectForKey:@"credentials"];
                Owner *userInfo = (Owner *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];

                NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userInfo.email,@"email",self.pet.name,@"petname",self.pet.simNumber,@"phone", nil];
                
                [myCon response:5 parameters:param];
                
                
                UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
                activity.frame = CGRectMake(150, 100, 20, 20);
                activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [activity startAnimating];
                [self.view addSubview:activity];
                
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    while ([myCon.APIResult isEqualToString:@"NOYET"])
                    {            }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [activity stopAnimating];
                        
                        if([self validate:myCon.APIResult])
                            [self.delegate newPetSaved:self.pet InViewController:self];
                    });
                });
            }
        }
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campos vacíos" message:@"Nombre y número SIM obligatorios." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
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
        message = [NSString stringWithFormat: @"Ya existe una mascota vinculada con el número %@ \nPor favor intenta nuevamente.",self.pet.simNumber];
    }
    else if([res isEqualToString:@"ERROR"])
    {
        title = @"Error de conexión";
        message = [NSString stringWithFormat: @"No hay conexión a internet.\nPor favor intenta nuevamente."];
    }
    else if([res isEqualToString:@"-2"])
    {
        title = @"Error interno";
        message = [NSString stringWithFormat: @"Hubo un error al realizar el registro.\nPor favor intenta nuevamente."];
    }
    
    if(![title isEqualToString:@"0"])
    {
        UIAlertView *showError = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [showError show];
        
        return NO;
    }
    
    return YES;
}


- (IBAction)cancelNewPet:(id)sender {

    if (editingMode) {
    
        [self.petDelegate cancelUpdateInViewController:self];
    
    } else{
        
        [self.delegate newpetCanceledInViewController:self];
        
    }
    
}



-(void)assignToPet:(Pet*)paramPet SwitchValuesInRow:(int)row AndSection:(int)section{
    
    UITableViewCell *cell = [self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    
    UISwitch *switchControl = (UISwitch*)[cell viewWithTag:100];
    
    switch (row) {
        case 0:
            paramPet.geofenceActivated = switchControl.on;
            break;
        case 1:
            paramPet.panic = switchControl.on;
            break;
        default:
            break;
    }
    
    
    if (!paramPet.geofenceActivated) {
        
        [paramPet.geofencePoints removeAllObjects];
        
        paramPet.geofencePoints = nil;
    }
    
}

-(BOOL)assignDataToPet:(Pet*)paramPet InTableViewSection:(int)section{
    
    UITextField *auxTextField;
    
    BOOL textFieldFilled = YES;
    
    for (int i = 0; i < [self.tableView numberOfRowsInSection:section]; i++) {
        
        UITableViewCell *cell;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
        
        auxTextField = (UITextField*)[cell viewWithTag:102];
        
        if([auxTextField isFirstResponder])
            [auxTextField resignFirstResponder];
        
        if ([auxTextField.text isEqualToString:@""]) {
            
            textFieldFilled = NO;
        }
        
        int indexAux = i;
        
        if (section == 1)
            indexAux = i + 2;
        
        switch (indexAux) {
            case 0:
                paramPet.name = auxTextField.text;
                break;
            case 1:{
                
                NSString *phoneRegex = @"^[2-9][0-9]{9}$";
                
                textFieldFilled = [InputValidator validateString:auxTextField.text withPattern:phoneRegex];
                
                if (textFieldFilled){
                    
                    paramPet.simNumber = auxTextField.text;
                
                }else{
                
                    UIAlertView *invalidPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Teléfono Inválido" message:@"El Teléfono del correo no es válido" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    
                    [invalidPhoneAlert show];
                }
                
                break;}
            default:
                break;
        }
        
    }
    
    
    return textFieldFilled;
}

-(BOOL)validateEmptyInput{
    
    
    for (int i = 0; i < 2; i++) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        UITextField *textfield = (UITextField*)[cell viewWithTag:102];
        
        if ([textfield.text isEqualToString:@""]) {
            
            return NO;
        }
        
    }
    
    return YES;
    
}



#pragma TableView Methods

-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (editingMode) {
        
        return 3;
    }
    
    return 2;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 1;
    }
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;
    
    if (indexPath.section == 0) {
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"InputCell"];
        
        UITextField *textField = (UITextField*)[cell viewWithTag:102];
        
        UILabel *textLabel = (UILabel*)[cell viewWithTag:101];
        
        textField.delegate = self;
        
        switch (indexPath.row) {
            case 0:
                textLabel.text = @"Nombre:";
                textField.text = self.pet.name;
                break;
            case 1:
                textLabel.text = @"SIM:";
                textField.keyboardType = UIKeyboardTypePhonePad;
                textField.text = self.pet.simNumber;
                break;
            default:
                break;
                
        }
    
        
    }else if(indexPath.section == 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        UILabel *textLabel = (UILabel*)[cell viewWithTag:101];

        UISwitch *switchControl = (UISwitch*)[cell viewWithTag:100];
        
        switchControl.on = NO;
        
        switch (indexPath.row) {

            case 0:
                
                textLabel.text = @"GeoFence";
            
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                
                [switchControl addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventValueChanged];
            
                switchControl.on = self.pet.geofenceActivated;
        
                break;
            case 1:

                textLabel.text = @"Panic";
                
                if (editingMode) switchControl.on = self.pet.panic;
                
                break;
            
            default:
                break;

        }
        
    }else if (indexPath.section == 2){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteCell"];
        
        UIButton *button  = (UIButton*)[cell viewWithTag:105];
        
        [button addTarget:self action:@selector(deletePet:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath) {
        
        [self performSegueWithIdentifier:@"GeoFence" sender:nil];
    }
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





#pragma mark TextField Methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}



#pragma mark Geofence Protocol Methods

-(void)geofenceSavedWithCoordinate:(CLLocationCoordinate2D)coordinate1 AndCoordinate2:(CLLocationCoordinate2D)coordinate2 InViewController:(UIViewController *)viewController{
    

    self.pet.geofencePoints = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:coordinate1.latitude],@"latitude1",[NSNumber numberWithDouble:coordinate1.longitude],@"longitude1",[NSNumber numberWithFloat:coordinate2.latitude],@"latitude2",[NSNumber numberWithDouble:coordinate2.longitude],@"longitude2", nil];
    
    
    self.pet.geofenceActivated = YES;
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)geofenceCanceledInViewController:(UIViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}




#pragma mark Navigation

-(void)showMap:(UISwitch*)switchControl{
    
    if (switchControl.on) {
        
        [self performSegueWithIdentifier:@"GeoFence" sender:Nil];
    
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"GeoFence"]) {
    
        UINavigationController *navigationController = segue.destinationViewController;
        
        GeoFenceMapViewController *geofenceController = (GeoFenceMapViewController*)[navigationController.viewControllers lastObject];
        
        geofenceController.delegate = self;
        
        if (self.pet.geofencePoints.count > 2) {
            
            CLLocationCoordinate2D pin1Location,pin2Location;
        
            pin1Location.latitude = [[self.pet.geofencePoints objectForKey:@"latitude1"] doubleValue];
            
            pin1Location.longitude = [[self.pet.geofencePoints objectForKey:@"longitude1"] doubleValue];
            
            Annotation *annotation1 = [[Annotation alloc] init];
            
            annotation1.coordinate = pin1Location;
            
            geofenceController.annotationArray = [[NSMutableArray alloc] init];
    
            [geofenceController.annotationArray addObject:annotation1];
            
            
            pin2Location.latitude = [[self.pet.geofencePoints objectForKey:@"latitude2"] doubleValue];
            
            pin2Location.longitude = [[self.pet.geofencePoints objectForKey:@"longitude2"] doubleValue];
            
            Annotation *annotation2 = [[Annotation alloc] init];
            
            annotation2.coordinate = pin2Location;
            
            [geofenceController.annotationArray addObject:annotation2];

        }
        
    }
    
}

-(void)deletePet:(id)sender{
    
    //agregar confirmación
    
    UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle:@"¿Está seguro que desea borrar?" message:nil delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Cancelar", nil];
    
    [confirmationAlert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
    
        [self.petDelegate deletePet:self.pet];
    }
}
@end
