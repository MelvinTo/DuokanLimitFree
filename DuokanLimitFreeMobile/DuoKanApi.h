//
//  DuoKanApi.h
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 13-7-8.
//  Copyright (c) 2013年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuoKanSessionInfo.h"
#import "Book+Utility.h"
#import "Record+Utility.h"

@protocol DuokanDatabaseAPI <NSObject>

- (Book *)createNewBook;
- (NSError*)save;
- (bool) checkIfBookExists:(Book *)book;
- (NSError*)deleteBook:(Book*)book;
- (Record*)createNewRecord;
- (NSError*)deleteRecord:(Record*)record;

@optional
- (NSArray*)getAllRecords;
- (NSArray*)getAllVisibleRecords;

@end

@protocol DuoKanApiDelegate <NSObject>

@optional

- (void) loginResult: (DuoKanSessionInfo*) session withError: (NSError*) err;
- (void) bookInfo: (Book*) book withError: (NSError*) err;
- (void) isOrdered: (BOOL) ordered forBook: (Book*) book withError: (NSError*) err;
- (void) orderResult: (BOOL) ordered forBook: (Book*) book withError: (NSError*) err;
- (void) mainPage: (NSData*)htmlData withError: (NSError*) err;
- (void) hideResult: (Book*) book withError: (NSError*) err userInfo:(NSDictionary*) info;
- (void) revealResult: (Book*) book withError: (NSError*) err;
- (void) logoutResult: (NSError*) err;

@end

@interface DuoKanApi : NSObject {
    id<DuokanDatabaseAPI> _dbAPI;
}

- (void) login: (NSString*) username withPassword: (NSString*) password withDelegate: (id <DuoKanApiDelegate>) delegate;
- (void) getMainPageWithDelegate: (id <DuoKanApiDelegate> ) delegate;
- (NSString*) getFreeBookURL: (NSData*) htmlData;
- (Book*) getBookInfo: (NSString*) url withDelegate: (id<DuoKanApiDelegate>) delegate;
- (Book*) parseBookHTML: (NSString*) htmlString;
- (void) isOrdered: (Book*) book inSession: (DuoKanSessionInfo*) session withDelegate: (id<DuoKanApiDelegate>) delegate;
- (void) order: (Book*) book inSession: (DuoKanSessionInfo*) session withDelegate: (id<DuoKanApiDelegate>) delegate;
- (void) hide: (Book*) book inSession: (DuoKanSessionInfo*) session withDelegate: (id<DuoKanApiDelegate>) delegate userInfo: (NSDictionary*) info;
- (void) reveal: (Book*) book inSession: (DuoKanSessionInfo*) session withDelegate: (id<DuoKanApiDelegate>) delegate;

- (NSNumber*) getRating: (NSString*) htmlString;
- (void) setDatabaseAPI: (id<DuokanDatabaseAPI>) api;
- (void) logout:(id<DuoKanApiDelegate>) delegate;

@end
