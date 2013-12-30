//
//  MascotasMasterViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/14/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPetViewController.h"

@interface PetsMasterViewController : UITableViewController <NewPetProtocol>

@property (nonatomic, strong) NSMutableArray *thePetList;

@end
