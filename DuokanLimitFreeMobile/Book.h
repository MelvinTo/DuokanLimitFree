//
//  Book.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-21.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * bookID;
@property (nonatomic, retain) NSString * cover;
@property (nonatomic, retain) NSNumber * oldPrice;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * hide;
@property (nonatomic, retain) Record *record;

@end
