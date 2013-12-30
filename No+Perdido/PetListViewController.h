//
//  PetListViewController.h
//  No+Perdido
//
//  Created by César Flores on 12/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocateViewController.h"
@interface PetListViewController : UITableViewController

@property (nonatomic, strong) id <LocatePetProtocol> delegate;


@end
