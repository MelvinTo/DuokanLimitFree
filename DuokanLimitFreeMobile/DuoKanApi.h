//
//  DuoKanApi.h
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 13-7-8.
//  Copyright (c) 2013年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuoKanSessionInfo.h"
#import "DuoKanBook.h"

@protocol DuoKanApiDelegate <NSObject>

@optional

- (void) loginResult: (DuoKanSessionInfo*) session withError: (NSError*) err;
- (void) bookInfo: (DuoKanBook*) book withError: (NSError*) err;
- (void) isOrdered: (BOOL) ordered forBook: (DuoKanBook*) book withError: (NSError*) err;
- (void) orderResult: (BOOL) ordered forBook: (DuoKanBook*) book withError: (NSError*) err;
- (void) mainPage: (NSData*)htmlData withError: (NSError*) err;

@end

@interface DuoKanApi : NSObject {
    
}


- (void) login: (NSString*) username withPassword: (NSString*) password withDelegate: (id <DuoKanApiDelegate>) delegate;
- (void) getMainPageWithDelegate: (id <DuoKanApiDelegate> ) delegate;
- (NSString*) getFreeBookURL: (NSData*) htmlData;
- (DuoKanBook*) getBookInfo: (NSString*) url withDelegate: (id<DuoKanApiDelegate>) delegate;
- (DuoKanBook*) parseBookHTML: (NSString*) htmlString;
- (void) isOrdered: (DuoKanBook*) book inSession: (DuoKanSessionInfo*) session withDelegate: (id<DuoKanApiDelegate>) delegate;
- (void) order: (DuoKanBook*) book inSession: (DuoKanSessionInfo*) session withDelegate: (id<DuoKanApiDelegate>) delegate;
- (NSNumber*) getRating: (NSString*) htmlString;

@end
