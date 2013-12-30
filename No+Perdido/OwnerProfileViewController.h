//
//  UserProfileViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnerProfileUpdateViewController.h"

@interface OwnerProfileViewController : UITableViewController <OwnerProtocol>


- (IBAction)editButtonTapped:(id)sender;
- (IBAction)logOutButtonTapped:(id)sender;

@end
