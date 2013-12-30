//
//  OwnerProfileUpdateViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "OwnerProfileUpdateViewController.h"
#import "InputValidator.h"
#import "Connection.h"

@interface OwnerProfileUpdateViewController ()

@end

@implementation OwnerProfileUpdateViewController{
    
    NSString *password;
    
    NSMutableArray *auxPhoneNumberArray;
    
    BOOL uno;
    BOOL dos;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    uno = YES;
    dos = NO;
    
    auxPhoneNumberArray  = [[NSMutableArray alloc] init];
    
    //auxPhoneNumberArray = self.editedOwner.phoneArray;
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 5;
            break;
        default:
            return 2;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *CellIdentifier = @"EditCell";
    
    if (indexPath.section == 2) CellIdentifier = @"PhoneCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITextField *cellTextField = (UITextField*)[cell viewWithTag:121];
    
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:120];
    
    cellTextField.delegate = self;

    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                cellLabel.text = @"Nombre";
                cellTextField.text = self.editedOwner.name;
                break;
            case 1:
                cellLabel.text = @"Apellido";
                cellTextField.text = self.editedOwner.lastName;
                break;
        }

    }else if(indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:
                cellLabel.text = @"E-mail";
                cellTextField.text = self.editedOwner.email;
                cellTextField.enabled = NO;
                cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
                break;
            case 1:
                cellLabel.text = @"Contraseña";
                cellTextField.text = self.editedOwner.password;
                cellTextField.secureTextEntry = YES;
                break;
            case 2:
                cellLabel.text = @"Contraseña";
                cellTextField.secureTextEntry = YES;
                cellTextField.placeholder = @"Repetir Contraseña";
                break;
            
        }
    
    }else if (indexPath.section == 2){
        
        cellTextField.keyboardType = UIKeyboardTypePhonePad;
        
        cellTextField.text = [self.editedOwner.phoneArray objectAtIndex:indexPath.row];
        cellLabel.text = [NSString stringWithFormat:@"Teléfono %d",indexPath.row+1];
        
        if (indexPath.row != 0) cellTextField.placeholder = @"Opcional";
        
        
    }
    
    
    return cell;
}


#pragma mark User Interactions

- (IBAction)cancelButtonTapped:(id)sender {
    
    [self validatePhoneNumbers];
    
    self.editedOwner.phoneArray = auxPhoneNumberArray;
    
    [self.delegate cancelOwnerProfileUpdateInViewController:self];
}

- (IBAction)saveButtonTapped:(id)sender {

    
    [self assignTelephones];
    
    if ([self validatePhoneNumbers])
    {
        
        if ([self validateAndAssignDataToOwner])
        {
            
            if ([password isEqualToString:@""] || [self.editedOwner.password isEqualToString:password])
            {
                //Procedemos a guardar los teléfonos
                
                NSString *toDeleteNumbers = @"";
                NSString *toSaveNumbers = @"";
                int u = 0, v = 0;
                
                for(int i = 0; i < 5; ++i)
                {
                    NSString *actualNumber = [auxPhoneNumberArray objectAtIndex:i];
                    
                    if([actualNumber isEqualToString:@""]) //La casilla i esta vacia
                    {
                        if(![[self.editedOwner.phoneArray objectAtIndex:i] isEqualToString:@""]) //La casilla antigua no era vacia
                        {
                            //Elimina el telefono en i
                            
                            toDeleteNumbers = [NSString stringWithFormat:@"%@&phone%d=%@",toDeleteNumbers,i+1,[self.editedOwner.phoneArray objectAtIndex:i]];
                            u++;
                        }
                    }
                    else //La casilla i tiene un valor
                    {
                        if([[self.editedOwner.phoneArray objectAtIndex:i] isEqualToString:@""]) //La casilla anterior está vacia
                        {
                            //Agregar telefono en i
                            
                            toSaveNumbers = [NSString stringWithFormat:@"%@&phone%d=%@",toSaveNumbers,i+1,actualNumber];
                            v++;
                        }
                        else if(![[self.editedOwner.phoneArray objectAtIndex:i] isEqualToString:actualNumber]) //Si la casilla anterior y la actual son diferetes
                        {
                            //Elimina y agrega el telefono en i
                            
                            toDeleteNumbers = [NSString stringWithFormat:@"%@&phone%d=%@",toDeleteNumbers,i+1,[self.editedOwner.phoneArray objectAtIndex:i]];
                            u++;
                            
                            toSaveNumbers = [NSString stringWithFormat:@"%@&phone%d=%@",toSaveNumbers,i+1,actualNumber];
                            v++;
                        }
                    }
                }
                
                UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
                
                activity.center = self.view.center;
                activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                
                [activity startAnimating];
                [self.view addSubview:activity];
                
                //Borrar
                if(u != 0)
                {
                    Connection *myCon1 = [[Connection alloc]init];
                    
                    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:toDeleteNumbers,@"deleteCad",[NSNumber numberWithInt:u],@"count",self.editedOwner.email,@"email", nil];
                    
                    [myCon1 response:4 parameters:param1];
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        
                        while ([myCon1.APIResult isEqualToString:@"NOYET"])
                        {            }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self validate:myCon1.APIResult withOpc:1];
                        });
                    });
                    
                }
                
                //Agregar
                if(uno && v != 0)
                {
                    Connection *myCon2 = [[Connection alloc]init];
                    
                    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:toSaveNumbers,@"saveCad",[NSNumber numberWithInt:v],@"count",self.editedOwner.email,@"email", nil];
                    
                    [myCon2 response:3 parameters:param1];
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        
                        while ([myCon2.APIResult isEqualToString:@"NOYET"])
                        {            }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self validate:myCon2.APIResult withOpc:2];
                        });
                    });
                    
                }
                
                uno = NO;
                
                if(uno && dos)
                {
                    self.editedOwner.phoneArray = auxPhoneNumberArray;
                    [self.delegate saveOwner:self.editedOwner ProfileUpdateInViewController:self];
                }
                
            }
            else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verifique Contraseñas" message:@"Las contraseñas deben coincidir" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
    
    }
}

-(BOOL) validate:(NSString*)res withOpc:(int)opc
{
    NSLog(@"APIResult = [%@]",res);
    
    NSString *title = @"0";
    NSString *message;

    if(opc == 1)
    {
        if([res isEqualToString:@"-1"])
        {
            title = @"Email inválido";
            message = [NSString stringWithFormat: @"Ya existe una cuenta registrada con el correo.\nPor favor intenta nuevamente."];
        }
        else if([res isEqualToString:@"ERROR"])
        {
            title = @"Error de conexión";
            message = [NSString stringWithFormat: @"No hay conexión a internet.\nPor favor intenta nuevamente."];
        }
        else if(![res isEqualToString:@"0"])
        {
            title = @"Error interno";
            message = [NSString stringWithFormat: @"Hubo un error interno.\nPor favor intenta nuevamente."];
        }
        
        if(![title isEqualToString:@"0"])
        {
            UIAlertView *showError = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [showError show];
            
            uno = NO;
            
            return NO;
        }
        
        return YES;
    }
    else
    {
        if([res isEqualToString:@"-1"])
        {
            title = @"Email inválido";
            message = [NSString stringWithFormat: @"Ya existe una cuenta registrada con el correo.\nPor favor intenta nuevamente."];
        }
        else if([res isEqualToString:@"ERROR"])
        {
            title = @"Error de conexión";
            message = [NSString stringWithFormat: @"No hay conexión a internet.\nPor favor intenta nuevamente."];
        }
        else if(![res isEqualToString:@"0"])
        {
            title = @"Error interno";
            message = [NSString stringWithFormat: @"Hubo un error interno.\nPor favor intenta nuevamente."];
        }
        
        if(![title isEqualToString:@"0"])
        {
            UIAlertView *showError = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [showError show];
            
            dos = NO;
            
            return NO;
        }
        
        
        return YES;
    }
}

#pragma mark Others

-(void)assignTelephones{
    
    NSMutableArray *theArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        
        UITextField *textField = (UITextField*)[cell viewWithTag:121];

        [theArray addObject:textField.text];
        
    }
    
    auxPhoneNumberArray = theArray;
}



-(BOOL)validatePhoneNumbers{
    
    BOOL validates = YES;
    
    int i = 0;
    
    for (NSString *phoneNumber in auxPhoneNumberArray) {
        
        
        if(![phoneNumber isEqualToString:@""])
        {
            NSString *phoneRegex = @"^[2-9][0-9]{9}$";
            
            validates = [InputValidator validateString:phoneNumber withPattern:phoneRegex];
            
        }else{
            
            if (i==0) {
                
                UIAlertView *invalidPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Teléfono Inválido" message:@"El primer teléfono no puede ser vacío" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [invalidPhoneAlert show];
                
                
                validates = NO;
                
                return validates;
                
            }
            
            validates = YES;
        }
        
        i++;
    }
    
    if (!validates) {
        
        UIAlertView *invalidPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Teléfono Inválido" message:@"El formato del teléfono no es válido" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [invalidPhoneAlert show];
        
    }
    
    
    return validates;
    
}

-(BOOL)validateAndAssignDataToOwner{
    
    UITableViewCell *cell;
    
    UITextField *cellTextField;
    
    BOOL validInput = YES;
    
    for (int i = 0; i < 2; i++) {
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        cellTextField = (UITextField*)[cell viewWithTag:121];
        
        if ([cellTextField.text isEqualToString:@""]) {
            
            validInput = NO;
            
            UIAlertView *invalidNameAlert = [[UIAlertView alloc] initWithTitle:@"Nombre Inválido" message:@"Ingresar Nombre y Apellido" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [invalidNameAlert show];
            
            
        }else{
            
            switch (i) {
                case 0:
                    self.editedOwner.name = cellTextField.text;
                    break;
                case 1:
                    self.editedOwner.lastName = cellTextField.text;
                    break;
                default:
                    break;
            }
            
        }
        
        
    }
    
    
    for (int i = 0; i < 3; i++) {
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        
        cellTextField = (UITextField*)[cell viewWithTag:121];
        
        
        if ([cellTextField.text isEqualToString:@""] && i != 2) {
            
            validInput =  NO;
            
        }else{
            
            
            switch (i) {
                case 1:
                    self.editedOwner.password = cellTextField.text;
                    break;
                case 2:
                    password = cellTextField.text;
                    break;
                default:
                    break;
            }
            
        }
        
    }
    
    
    
    return validInput;
    
}



#pragma mark TextField Methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0; i < 3; i++) {
        
        for (int j = 0; j < [self.tableView numberOfRowsInSection:i]; j++) {
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            
            UITextField *textField = (UITextField*)[cell viewWithTag:121];
            
            if ([textField isFirstResponder]) {
                
                [textField resignFirstResponder];
            }
            
        }
    }

}
@end
