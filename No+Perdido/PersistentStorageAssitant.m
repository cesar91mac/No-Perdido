//
//  PersistentStorageAssitant.m
//  No+Perdido
//
//  Created by Cesar Flores on 10/31/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import "PersistentStorageAssitant.h"

@implementation PersistentStorageAssitant


+(void)saveArray:(NSMutableArray*)array InDocumentsFolderToFileWithName:(NSString*)fileName{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [NSKeyedArchiver archiveRootObject:array toFile:path];

}

+(void)deletePetArrayFromDocumentsFolderInFile:(NSString*)fileName{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSError *error;
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
}


+(void)saveCustomOwner:(Owner*)owner ToUserDefaultsWithKey:(NSString*)key{
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:owner];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(void)removeCustomOwnerFromUserDefaultsWithKey:(NSString*)key{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(Owner*)getCustomOwnerFromUserDefaultsWithKey:(NSString*)key{
    
    NSData *encodedOwner = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    Owner *currentOwner = (Owner*)[NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];

    return currentOwner;
}

@end
