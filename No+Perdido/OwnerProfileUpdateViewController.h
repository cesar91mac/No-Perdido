//
//  OwnerProfileUpdateViewController.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"




@interface OwnerProfileUpdateViewController : UITableViewController <UITextFieldDelegate>

@property  (nonatomic, strong) id <OwnerProtocol> delegate;

- (IBAction)cancelButtonTapped:(id)sender;

- (IBAction)saveButtonTapped:(id)sender;

@property (nonatomic, strong) Owner *editedOwner;


@end
