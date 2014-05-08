//
//  DuoKanCoreDataUtil.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-23.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuoKanApi.h"

@interface DuoKanCoreDataUtil : NSObject<DuokanDatabaseAPI> {
}

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString *persistentStorePath;

+ (DuoKanCoreDataUtil*) sharedUtility;


@end
