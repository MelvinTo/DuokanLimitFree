//
//  DuoKanBook.h
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-3.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuoKanBook : NSObject {
    NSString* _ID;
    NSString* _title;
    NSString* _price;
    NSString* _oldPrice;
    NSString* _cover;
    NSString* _url;
    NSString* _author;
    NSNumber* _rating;
}

@property (nonatomic) NSString* ID;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* price;
@property (nonatomic) NSString* oldPrice;
@property (nonatomic) NSString* cover;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* author;
@property (nonatomic) NSNumber* rating;

- (NSDictionary*) toDict;
- (NSString*) ratingString;

@end
