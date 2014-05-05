//
//  DuoKanDelegate.m
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-5.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanDelegate.h"
#import "DuoKanMobileNotification.h"
#import "DuoKanLocalStorage.h"
#import "DuoKanDebug.h"

@implementation DuoKanDelegate

- (void)loginResult:(DuoKanSessionInfo *)session withError:(NSError *)err {
    if(session == nil) {
        NSLog(@"Failed to login because: %@", err);
        [_callback DuokanDelegate:self failure:nil withError:err];
        return;
    }
    
    [_api getMainPageWithDelegate:self];
}

- (void)mainPage:(NSData *)htmlData withError:(NSError *)err {
    if(htmlData == nil) {
        NSLog(@"Failed to get main page because: %@", err);
        [_callback DuokanDelegate:self failure:nil withError:err];
        return;
    }
    
    NSString* freeBookURL = [_api getFreeBookURL:htmlData];
//    freeBookURL = @"http://www.duokan.com/book/46366";
    [_api getBookInfo:freeBookURL withDelegate:self];
}

- (void)bookInfo:(Book *)book withError:(NSError *)err {
    if(book == nil) {
        NSLog(@"Failed to get book info because: %@", err);
        [_callback DuokanDelegate:self failure:book withError:err];
        return;
    }
    
    // check if this book is already ordered
    [_api isOrdered:book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
}

- (void)isOrdered:(BOOL)ordered forBook: book withError:(NSError *)err {
    if(err == nil) {
        if (ordered) {
            NSLog(@"Book is already ordered");
            [[DuoKanDebug sharedDebugger] produceDebugLog:[NSString stringWithFormat:@"书已经购买，无需再买: %@", book]];
        } else {
            NSLog(@"Book is not ordered");
            [_api order:book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self];
        }
    } else {
        NSLog(@"Meet error when checking order status: %@", err);
        [[DuoKanDebug sharedDebugger] produceDebugLog:[NSString stringWithFormat:@"书抢购失败: %@", [err localizedDescription]]];
    }
    [_callback DuokanDelegate:self success:book];
}

- (void)orderResult:(BOOL)ordered forBook:(Book *)book withError:(NSError *)err {
    if(err == nil) {
        if(_notification) {
            [_notification notifyBookOrdered:book];
        }
        [[DuoKanDebug sharedDebugger] produceDebugLog:[NSString stringWithFormat:@"书抢购成功: %@", book]];
    } else {
        NSLog(@"Meet error when ordering book %@: %@", book.title, err);
        [[DuoKanDebug sharedDebugger] produceDebugLog:[NSString stringWithFormat:@"书抢购失败: %@", [err localizedDescription]]];
    }
}

- (id) init {
    self = [super init];
    if (self) {
        _notification = [[DuoKanMobileNotification alloc] init];
    }
    return self;
}

- (void)setCallback:(id<DuokanDelegateCallback>)callback {
    _callback = callback;
}

- (void) run {
    
    _api =  [[DuoKanApi alloc] init];
    _util = [[DuoKanCoreDataUtil alloc] init];
    [_api setDatabaseAPI:_util];
    
    DuoKanLocalStorage* storage = [DuoKanLocalStorage sharedStorage];
    NSString* username = [storage getUsername];
    NSString* password = [storage getPassword];
    
    [_api login:username withPassword:password withDelegate:self];

}

@end
