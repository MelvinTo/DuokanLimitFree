//
//  DuoKanApiTest.m
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-2.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DuoKanApi.h"
#import "DuokanVariables.h"
#import "DuoKanCoreDataUtil.h"

static NSString* username = @"melvinto.01@gmail.com";
static NSString* password = @"vMm7opDLRECL7c";

@interface DuoKanApiTest : XCTestCase<DuoKanApiDelegate> {
    BOOL _requestComplete;
    Book* _book;
    NSData* _testHtmlData;
}

@property BOOL requestComplete;

@end

@implementation DuoKanApiTest

@synthesize requestComplete = _requsetComplete;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)loginResult:(DuoKanSessionInfo *)session withError:(NSError *)err {
    XCTAssertNil(err, @"should have no error when logging in");
    self.requestComplete = YES;
}

- (void)bookInfo:(Book *)book withError:(NSError *)err {
    XCTAssertNil(err, @"should have no error when getting info of book: %@", book);
    self.requestComplete = YES;
    _book = book;
}

- (void)testLogin {
    
    DuoKanApi* api = [[DuoKanApi alloc] init];
    
    self.requestComplete = NO;

    [api login:username withPassword:password withDelegate:self];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    // Begin a run loop terminated when the downloadComplete it set to true
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
}

- (void)testGetBookInfo {
    NSString* bookURL = @"http://www.duokan.com/book/46637";
    
    DuoKanApi* api = [[DuoKanApi alloc] init];
    
    self.requestComplete = NO;

    [api getBookInfo:bookURL withDelegate:self];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    // Begin a run loop terminated when the downloadComplete it set to true
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)testParseBookHTML {
    NSString* html = @"<script type=\"text/javascript\"> \n\
    window.dk_data = { \n\
        book_id : 'bcc917dd824b4c96857a138337a75dc2', \n\
        book : { \n\
            sid : '46637', \n\
            id : 'bcc917dd824b4c96857a138337a75dc2', \n\
            title : '男人除了性还在想什么？', \n\
            price : '0.0', \n\
            old_price : '0.0', \n\
            \n\
            cover : 'http://cover.read.duokan.com/mfsv2/download/s010/p01MicY0Iqdo/V7AkU6QpVmtQcn.jpg!vt',\n\
            url : '/book/46637', \n\
            webreader : 1, \n\
            authors : '多看君' \n\
        } \n\
    } \n\
    \n\
    window.dk_data.comments_url = '/review/46637';\n\
    \n\
    </script> ";
    
    DuoKanApi* api = [[DuoKanApi alloc] init];
    [api setDatabaseAPI: [[DuoKanCoreDataUtil alloc] init]];
    
    Book* book = [api parseBookHTML:html];
    XCTAssertNotNil(book, @"book object should not be nil");
    XCTAssertTrue([book.title isEqualToString:@"男人除了性还在想什么？"], @"should have correct title");
    XCTAssertTrue([book.bookID isEqualToString:@"bcc917dd824b4c96857a138337a75dc2"], @"book id should exist");
    XCTAssertTrue([book.price isEqualToNumber:[NSNumber numberWithFloat:0.0]], @"book price should exist");
}

- (void)isOrdered:(BOOL)ordered forBook: book withError:(NSError *)err {
    if (ordered) {
        NSLog(@"already ordered!");
    } else {
        NSLog(@"not ordered yet");
    }
    if (err) {
        NSLog(@"some error when checking book: %@", err);
    }
    self.requestComplete = YES;
}

- (void) testIsOrdered {
    DuoKanApi* api =  [[DuoKanApi alloc] init];
    DuoKanCoreDataUtil* util = [[DuoKanCoreDataUtil alloc] init];
    [api setDatabaseAPI: util];
    
    Book* book = [util createNewBook];
    book.bookID = @"bcc917dd824b4c96857a138337a75dc2";
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    self.requestComplete = NO;
    [api isOrdered:book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
    
    // Begin a run loop terminated when the downloadComplete it set to true
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

}

- (void)orderResult:(BOOL)ordered forBook: book withError:(NSError *)err {
    if (ordered) {
        NSLog(@"ordered!");
    } else {
        NSLog(@"failed to order because: %@", err);
    }
    self.requestComplete = YES;
}

- (void) testOrder {
    DuoKanApi* api =  [[DuoKanApi alloc] init];
    DuoKanCoreDataUtil* util = [[DuoKanCoreDataUtil alloc] init];
    [api setDatabaseAPI: util];
    
    Book* book = [util createNewBook];
    book.bookID = @"bcc917dd824b4c96857a138337a75dc2";
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    self.requestComplete = NO;
    [api order:book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
    
    // Begin a run loop terminated when the downloadComplete it set to true
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    

}

- (void)mainPage:(NSData *)htmlData withError:(NSError *)err {
    XCTAssertNil(err, @"should have no error when getting main page");
    _testHtmlData = htmlData;
    self.requestComplete = YES;
}

- (void) testGetFreeBooks {
    DuoKanApi* api =  [[DuoKanApi alloc] init];
    DuoKanCoreDataUtil* util = [[DuoKanCoreDataUtil alloc] init];
    [api setDatabaseAPI: util];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];

    // login
    self.requestComplete = NO;
    [api login:username withPassword:password withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

    // get main page
    self.requestComplete = NO;
    _testHtmlData = nil;
    [api getMainPageWithDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

    // get free book link
    XCTAssertNotNil(_testHtmlData, @"html data should be available");
    NSString* freeBookURL = [api getFreeBookURL:_testHtmlData];
    
    // get book info
    _book = nil;
    self.requestComplete = NO;
    [api getBookInfo:freeBookURL withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    // check if it is ordered already
    self.requestComplete = NO;
    [api isOrdered:_book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    // order it if not ordered yet
    self.requestComplete = NO;
    [api order:_book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void) testGetRating {
    DuoKanApi* api = [[DuoKanApi alloc] init];
    NSString* htmlString = @"<div class=\"m-bookdata j-bookdata f-cb\" itemscope=\"\" itemtype=\"http://schema.org/Book\">\
    <div class=\"cover\" id=\"cover-img\">\
    <a href=\"/book/46415\" hidefocus=\"hifefocus\">\
    <img itemprop=\"image\" src=\"http://cover.read.duokan.com/mfsv2/download/s010/p01ZorusYBGK/q717FO2om289zo.jpg!e\" alt=\"2666\" ondragstart=\"return false;\" oncontextmenu=\"return false;\" onload=\"onLoadImg(this);\" style=\"display: block;\" data-pinit=\"registered\">\
    </a>\
    </div>\
    <div class=\"desc\">\
    <h3>2666</h3>\
    \
    \
    <div class=\"u-stargrade\" itemprop=\"aggregateRating\" itemscope=\"\" itemtype=\"http://schema.org/AggregateRating\">\
    <div class=\"icon grade0\"></div>\
    \
    \
    </div>\
    <div class=\"cnt\">\
    <div class=\"data\">\
    <table>\
    \
    <tbody><tr>\
    <td class=\"col0\">作者：</td>\
    <td class=\"author\" itemprop=\"author\">\
    \
    \
    \
    <a href=\"/author/26210-1-1\" target=\"_blank\">【智利】罗贝托·波拉尼奥</a>\
    \
    </td>\
    </tr>\
    \
    \
    \
    <tr><td class=\"col0\">译者：</td><td class=\"author\"><span>赵德明</span></td></tr>\
    \
    \
    \
    \
    \
    <tr><td class=\"col0\">版权：</td><td class=\"published\" itemprop=\"copyrightHolder\"><a href=\"/publisher/821\" target=\"_blank\">北京世纪文景文化传播公司</a></td></tr>\
    \
    \
    \
    <tr><td class=\"col0\">出版：</td><td itemprop=\"datePublished\">2012-01-01</td></tr>\
    \
    </tbody></table>\
    </div>\
    \
    \
    \
    \
    \
    <div class=\"pay\">\
    <div class=\"price\">\
    \
    <em>¥ 12.00</em>\
    \
    \
    <span class=\"u-sep\">|</span>\
    \
    \
    <i>原价<del>¥ 45.00</del></i>\
    \
    \
    <i>纸书<del>¥ 69.00</del></i>\
    \
    \
    \
    \
    <b class=\"discount\">1.7折</b>\
    \
    \
    </div>\
    <div class=\"coupon j-coupon\" style=\"display:none\">\
    <a href=\"/pay/46415#coupon\" class=\"u-coupon-itm\"><b class=\"icn-coupon2\"></b>购书券兑换</a>\
    </div>\
    <div class=\"act j-act f-cb\" style=\"\">\
    <div class=\"btn j-buyarea f-cb\">\
    \
    \
    <a href=\"/reader?id=95543faf31e0416ab4d9fa3559e71b5d\" class=\"u-btn2\" hidefocus=\"hidefocus\" target=\"_blank\">阅读</a>\
    \
    \
    <a onclick=\"_hmt.push(['_trackEvent', 'book_detail_page', 'pay_click'])\" href=\"/pay/46415\" class=\"u-btn j-buy\" hidefocus=\"hidefocus\">购买全本</a>\
    \
    \
    </div>\
    <div class=\"other j-action\"><ul class=\"f-cb\">\
    \
    <li class=\"cart\"><a class=\"j-cart\" href=\"javascript:void(0);\" hidefocus=\"hidefocus\">加入购物车</a><span style=\"display:none;\" href=\"javascript:void(0);\">已加入</span><span class=\"u-sep\">|</span></li>\
    \
    \
    <li><a class=\"j-fav\" href=\"javascript:void(0);\" hidefocus=\"hidefocus\">收藏</a><a style=\"display:none;\" href=\"javascript:void(0);\" class=\"j-cancel-fav\">已收藏</a><span class=\"u-sep\">|</span></li>\
    \
    <li class=\"\">\
    <a href=\"javascript:void(0);\" class=\"j-share\" hidefocus=\"hidefocus\">分享</a>\
    \
    <span class=\"u-sep\">|</span>\
    \
    </li>\
    \
    <li class=\"u-gift\"><a href=\"/giving/46415\" hidefocus=\"hidefocus\">赠送<b class=\"icn-gift\"></b></a></li>\
    \
    </ul>\
    </div>\
    </div>\
    </div>\
    </div>\
    </div>\
    </div>";
    
    NSNumber* rating = [api getRating:htmlString];
    XCTAssertEqualObjects(rating, [NSNumber numberWithInt:0], @"Rating should be 0");
}

- (void) testOrderOneBook {
    DuoKanApi* api =  [[DuoKanApi alloc] init];
    DuoKanCoreDataUtil* util = [[DuoKanCoreDataUtil alloc] init];
    [api setDatabaseAPI: util];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    // login
    self.requestComplete = NO;
    [api login:username withPassword:password withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    // get book info
    _book = nil;
    self.requestComplete = NO;
    [api getBookInfo:@"http://www.duokan.com/book/46988" withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    // check if it is ordered already
    self.requestComplete = NO;
    [api isOrdered:_book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    // order it if not ordered yet
    self.requestComplete = NO;
    [api order:_book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
    while (!self.requestComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

@end
