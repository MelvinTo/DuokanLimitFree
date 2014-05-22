//
//  DuoKanTestMobileNotification.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-16.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DuoKanMobileNotification.h"
#import "DuoKanCoreDataUtil.h"

@interface DuoKanTestMobileNotification : XCTestCase

@end

@implementation DuoKanTestMobileNotification

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNotifyBookOrdered {
    DuoKanCoreDataUtil* util = [DuoKanCoreDataUtil sharedUtility];
    
    Book* book = [util createNewBook];
    book.title = @"三国演义";
    book.price = [NSNumber numberWithFloat:6.0];
    book.oldPrice = [NSNumber numberWithFloat:12.0];
    book.bookID = @"123455";
    book.rating = [NSNumber numberWithInt:8];
    
    DuoKanMobileNotification* notif = [[DuoKanMobileNotification alloc] init];
    [notif notifyBookOrdered:book];
}

@end
