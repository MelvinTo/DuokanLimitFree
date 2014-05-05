//
//  Record.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-23.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSDate * orderTime;
@property (nonatomic, retain) NSManagedObject *book;

@end
