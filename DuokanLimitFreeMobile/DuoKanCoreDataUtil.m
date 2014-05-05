//
//  DuoKanCoreDataUtil.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-23.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanCoreDataUtil.h"

@implementation DuoKanCoreDataUtil

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeUrl = [NSURL fileURLWithPath:self.persistentStorePath];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        NSError *error = nil;
        NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
        NSAssert3(persistentStore != nil, @"Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSString *)persistentStorePath {
    
    if (_persistentStorePath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths lastObject];
        _persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"TopSongs.sqlite"];
    }
    return _persistentStorePath;
}


- (Book *)createNewBook {
    Book *book = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Book"
                                      inManagedObjectContext:[self managedObjectContext]];
    return book;
}

- (NSError*)saveNewBook:(Book *)book {
    return nil;
}

@end
