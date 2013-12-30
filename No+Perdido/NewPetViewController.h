//
//  NewPetViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/16/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoFenceMapViewController.h"
#import "Pet.h"

@class PetsMasterViewController;
@class Pet;


@protocol NewPetProtocol <NSObject>

-(void)newPetSaved:(Pet*)pet InViewController:(UIViewController*)viewController;

-(void)newpetCanceledInViewController:(UIViewController*)viewController;

@end




@interface NewPetViewController : UITableViewController <UITextFieldDelegate,GeofenceProtocol,UIAlertViewDelegate>

- (IBAction)saveNewPet:(id)sender;

- (IBAction)cancelNewPet:(id)sender;






@property (nonatomic, strong) Pet *pet;

@property (nonatomic, strong) id <NewPetProtocol> delegate;

@property (nonatomic,strong) id <PetUpdateProtocol> petDelegate;

@end
