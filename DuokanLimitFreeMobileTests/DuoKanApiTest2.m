//
//  DuoKanApiTest2.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-6-6.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DuoKanApi.h"
#import "DuokanVariables.h"
#import "DuoKanCoreDataUtil.h"

static NSString* username = @"melvinto.01@gmail.com";
static NSString* password = @"vMm7opDLRECL7c";


@interface DuoKanApiTest2 : XCTestCase<DuoKanApiDelegate> {
    BOOL _requestComplete;
}

@property BOOL requestComplete;

@end


@implementation DuoKanApiTest2

@synthesize requestComplete = _requsetComplete;


- (void)bookInfo:(Book *)book withError:(NSError *)err {
    XCTAssertNil(err, @"should have no error when getting info of book: %@", book);
    self.requestComplete = YES;
    NSLog(@"book: %@", book);
    XCTAssertEqualObjects(book.bookID, @"ad7ccc166cb64d32ab53b9deb2d9b870", @"Book id should be equal");
    XCTAssertEqualObjects(book.title, @"冷人物（中国故事）", @"Book title should be equal");

}

- (void) testGetBookInfo {
    self.requestComplete = NO;
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    DuoKanApi* api = [DuoKanApi api:self withDatabase:[DuoKanCoreDataUtil sharedUtility]];
    [api getBook:@"ad7ccc166cb64d32ab53b9deb2d9b870"];
    
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

@end
