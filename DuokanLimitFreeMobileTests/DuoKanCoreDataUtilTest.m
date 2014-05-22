//
//  DuoKanCoreDataUtilTest.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-7.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DuoKanCoreDataUtil.h"

@interface DuoKanCoreDataUtilTest : XCTestCase

@end

@implementation DuoKanCoreDataUtilTest

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

- (void)testCheckIfExists {
    DuoKanCoreDataUtil* util = [DuoKanCoreDataUtil sharedUtility];
    Book* book = [util createNewBook];
    book.bookID = @"testBookID";
    NSError* error = [util save];
    XCTAssertNil(error, @"book should be saved successfully");
    
    BOOL result = [util checkIfBookExists:book];
    XCTAssertTrue(result, @"Book should exist in database");
    
    NSError* deleteError = [util deleteBook:book];
    XCTAssertNil(deleteError, @"Book should be deleted successfully");
}

- (void)testGetAllRecords {
    DuoKanCoreDataUtil* util = [DuoKanCoreDataUtil sharedUtility];
    Book* book = [util createNewBook];
    book.bookID = @"testBookID";
    NSError* error = [util save];
    XCTAssertNil(error, @"Book should be saved successfully");
    
    Record* record = [util createNewRecord];
    record.book = book;
    error = [util save];
    XCTAssertNil(error, @"Record should be saved successfully");
    
    NSArray* array = [util getAllRecords];
    XCTAssertTrue([array count] > 0, @"Should have elements in this array");
    
    error = [util deleteRecord:record];
    XCTAssertNil(error, @"No error should occur when deleting record");
    
    error = [util save];
    XCTAssertNil(error, @"Record should be deleted successfully");
    
    error = [util deleteBook:book];
    XCTAssertNil(error, @"No error should occur when deleting book");

    error = [util save];
    XCTAssertNil(error, @"Book should be deleted successfully");
}

@end
