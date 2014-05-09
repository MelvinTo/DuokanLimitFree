//
//  DuoKanCoreDataUtil.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-23.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanCoreDataUtil.h"

@interface NSManagedObject(IsNew)

/*!
 @method isNew
 @abstract   Returns YES if this managed object is new and has not yet been saved yet into the persistent store.
 */
-(BOOL)isNew;

@end

@implementation NSManagedObject(IsNew)

-(BOOL)isNew {
    NSDictionary *vals = [self committedValuesForKeys:nil];
    return [vals count] == 0;
}

@end

@implementation DuoKanCoreDataUtil

+ (DuoKanCoreDataUtil *)sharedUtility {
    static DuoKanCoreDataUtil* _shared = nil;
    
    @synchronized(_shared) {
        if (_shared == nil) {
            _shared = [[DuoKanCoreDataUtil alloc] init];
        }
    }
    
    return _shared;
}

- (void) setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError* error;
    NSString* path = [self persistentStorePath];
    NSURL* storeLocation = [NSURL fileURLWithPath:path];
                            
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeLocation options:nil error:&error];
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
    
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext == nil) {
        [self setupManagedObjectContext];
    }
    return _managedObjectContext;
}

- (NSString *)persistentStorePath {
    
    if (_persistentStorePath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths lastObject];
        _persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"Book.sqlite"];
    }
    return _persistentStorePath;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DuokanModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (Book *)createNewBook {
    Book *book = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Book"
                                      inManagedObjectContext:[self managedObjectContext]];
    return book;
}

- (NSError *)save {
    NSError *error = nil;
    
    NSLog(@"managedObjectContext for utility: %@", [self managedObjectContext]);
    
    [[self managedObjectContext] save:&error];
    
    if (error) {
        NSLog(@"Failed to commit coredata change: %@", [error localizedDescription]);
        return error;
    }
    
    return nil;
}

- (void)rollback {
    [[self managedObjectContext] rollback];
}

- (bool) checkIfBookExists:(Book *)book {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookID == %@", book.bookID];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:managedObjectContext];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *fetchError = nil;
    NSArray *fetchedBooks=[managedObjectContext executeFetchRequest:request error:&fetchError];
    
    if (!fetchError) {
        for (NSManagedObject* bookRecord in fetchedBooks) {
            if (! [bookRecord isNew]) {
                return YES;
            }
        }
        return NO;
    } else {
        return NO;
    }

}

- (NSError*)deleteBook:(Book*)book {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookID == %@", book.bookID];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:managedObjectContext];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *fetchError = nil;
    NSArray *fetchedBooks=[managedObjectContext executeFetchRequest:request error:&fetchError];
    
    if (!fetchError) {
        for (NSManagedObject* bookRecord in fetchedBooks) {
            [managedObjectContext deleteObject:bookRecord];
        }
        return nil;
    } else {
        return fetchError;
    }
}

- (Record*)createNewRecord {
    Record *record = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Record"
                  inManagedObjectContext:[self managedObjectContext]];
    return record;
}


- (NSError*)deleteRecord:(Record*)record {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderTime == %@ and book.bookID = %@ ", record.orderTime, [((Book*) record.book) bookID] ];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:managedObjectContext];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *fetchError = nil;
    NSArray *fetchedBooks=[managedObjectContext executeFetchRequest:request error:&fetchError];
    
    if (!fetchError) {
        for (NSManagedObject* bookRecord in fetchedBooks) {
            [managedObjectContext deleteObject:bookRecord];
        }
        return nil;
    } else {
        return fetchError;
    }

}

- (NSArray*) getAllRecords {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSError *fetchError = nil;
    NSArray *fetchedBooks=[managedObjectContext executeFetchRequest:request error:&fetchError];
    
    if (!fetchError) {
        return fetchedBooks;
    } else {
        return nil;
    }
}

@end
