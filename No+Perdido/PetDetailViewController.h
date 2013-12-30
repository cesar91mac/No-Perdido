//
//  PetDetailViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/16/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pet.h"
#import "PetsMasterViewController.h"

@interface PetDetailViewController : UITableViewController <PetUpdateProtocol>

@property (nonatomic, strong) Pet *selectedPet;

@property (nonatomic, strong) PetsMasterViewController *petMasterViewController;

@end
