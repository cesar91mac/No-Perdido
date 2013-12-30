//
//  UbicarViewController.m
//  No+Perdido
//
//  Created by César Flores on 12/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "LocateViewController.h"
#import "PetListViewController.h"
#import "Annotation.h"
#import "Pet.h"
#import "Connection.h"

@interface LocateViewController ()

@end

@implementation LocateViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark LocatePetProtocol

-(void)locatePet:(Pet *)pet InViewController:(UIViewController *)viewController {
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    //Petición al servidor
    
    Connection *myCon = [[Connection alloc] init];
    
    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:pet.simNumber,@"phone", nil];
    
    [myCon response:8 parameters:param1];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        while ([myCon.APIResult isEqualToString:@"NOYET"])
        {            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self validate:myCon.APIResult petData:myCon.JSONResult petName:pet.name];
        });
    });
}


-(void) validate:(NSString*)res petData:(NSMutableDictionary*)jsonObject petName:(NSString*)name
{
    NSLog(@"APIResult = [%@]",res);
    
    NSString *title = @"0";
    NSString *message;
    
    if([res isEqualToString:@"ERROR"])
    {
        title = @"Error de conexión";
        message = [NSString stringWithFormat: @"No hay conexión a internet.\nPor favor intenta nuevamente."];
    }
    else if([res isEqualToString:@"-1"])
    {
        title = @"Error interno";
        message = [NSString stringWithFormat: @"Hubo un error al realizar la petición.\nPor favor intenta nuevamente."];
    }
    
    if(![title isEqualToString:@"0"])
    {
        UIAlertView *showError = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [showError show];
    }
    else
    {
        Annotation *locatedPetAnnotation = [[Annotation alloc] init];

        CLLocationCoordinate2D coordinate;

        NSMutableDictionary *petLocation = [[NSMutableDictionary alloc] initWithDictionary:[jsonObject objectForKey:@"pet"]];
        
        coordinate.latitude = [[petLocation objectForKey:@"latitude"] doubleValue];
        coordinate.longitude = [[petLocation objectForKey:@"longitude"] doubleValue];
        
        locatedPetAnnotation.coordinate = coordinate;
        locatedPetAnnotation.title = name;
        
        [self.locatePetMapView addAnnotation:locatedPetAnnotation];
        
        [self.locatePetMapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000) animated:YES];
        
        NSLog(@"[%@][%@]",[petLocation objectForKey:@"latitude"],[petLocation objectForKey:@"longitude"]);
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UINavigationController *navigationController = segue.destinationViewController;
    
    PetListViewController *petListViewController =  [navigationController.viewControllers objectAtIndex:0];
    
    petListViewController.delegate = self;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
