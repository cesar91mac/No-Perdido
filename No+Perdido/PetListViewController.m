//
//  PetListViewController.m
//  No+Perdido
//
//  Created by César Flores on 12/18/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "PetListViewController.h"
#import "Pet.h"
@interface PetListViewController ()

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;

@property (nonatomic, strong) NSMutableArray *thePetList;

@end

@implementation PetListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PetList.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) { //defaultManager es un método de clase que crea una instancia de NSFilManager
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        self.thePetList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.thePetList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *namePetLabel = (UILabel*)[cell viewWithTag:101];
    
    Pet *petForCell = [self.thePetList objectAtIndex:indexPath.row];
    
    namePetLabel.text = petForCell.name;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *selecetedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selecetedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *deselectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (deselectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        deselectedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}



- (IBAction)cancelButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTapped:(id)sender {
    
    Pet *selectedPet = [self.thePetList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    
    [self.delegate locatePet:selectedPet InViewController:self];
    

}
@end
