//
//  PersistentStorageAssitant.h
//  No+Perdido
//
//  Created by Cesar Flores on 10/31/13.
//  Copyright (c) 2013 Cesar Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Owner.h"

@interface PersistentStorageAssitant : NSObject


+(void)saveArray:(NSMutableArray*)array InDocumentsFolderToFileWithName:(NSString*)fileName;

+(void)deletePetArrayFromDocumentsFolderInFile:(NSString*)fileName;

+(void)saveCustomOwner:(Owner*)owner ToUserDefaultsWithKey:(NSString*)key;

+(Owner*)getCustomOwnerFromUserDefaultsWithKey:(NSString*)key;

+(void)removeCustomOwnerFromUserDefaultsWithKey:(NSString*)key;

@end
