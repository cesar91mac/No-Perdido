//
//  MascotasMasterViewController.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/14/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "PetsMasterViewController.h"
#import "PetDetailViewController.h"
#import "Pet.h"
#import "PersistentStorageAssitant.h"

@interface PetsMasterViewController ()

@end

@implementation PetsMasterViewController



- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"PetList.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) { //defaultManager es un método de clase que crea una instancia de NSFilManager
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        self.thePetList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
    }
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    NSLog(@"Entra");
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.thePetList) {
        
        return 1;
    }
    
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.thePetList) {
        
        return self.thePetList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (self.thePetList.count > 0) {

        Pet *petAtIndex = [self.thePetList objectAtIndex:indexPath.row];
        
        UILabel *label = (UILabel*)[cell viewWithTag:1000];
        
        label.text = petAtIndex.name;
        
        UILabel *detailLabel = (UILabel*)[cell viewWithTag:1001];
        
        detailLabel.text = petAtIndex.status ? @"Activado" : @"Desactivado";
        
    }
    

    
    return cell;
}


#pragma mark New Pet Protocol

-(void)newPetSaved:(Pet *)pet InViewController:(UIViewController *)viewController{
    
    if (!self.thePetList) self.thePetList = [[NSMutableArray alloc] init];

    [self.thePetList addObject:pet];

    [PersistentStorageAssitant saveArray:self.thePetList InDocumentsFolderToFileWithName:@"PetList.plist"];
    
    [self.tableView reloadData];
    
    [viewController dismissViewControllerAnimated:YES completion:Nil];
}

-(void)newpetCanceledInViewController:(UIViewController *)viewController{
    
    [viewController dismissViewControllerAnimated:YES completion:Nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"NewPet"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        NewPetViewController *newPetViewController =  (NewPetViewController*)[navigationController.viewControllers lastObject];
        
        newPetViewController.delegate = self;
    
    }else if ([segue.identifier isEqualToString:@"PetDetail"]){
        
        PetDetailViewController *petDetailViewController = segue.destinationViewController;
        
        petDetailViewController.selectedPet = [self.thePetList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        petDetailViewController.petMasterViewController = self;
    }
    
}

@end
