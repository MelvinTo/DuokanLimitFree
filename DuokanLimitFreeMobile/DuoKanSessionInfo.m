//
//  DuoKanSessionInfo.m
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 13-7-8.
//  Copyright (c) 2013年 Melvin Tu. All rights reserved.
//

#import "DuoKanSessionInfo.h"

@implementation DuoKanSessionInfo

@synthesize appID = _appID;
@synthesize userID = _userID;
@synthesize deviceID = _deviceID;
@synthesize token = _token;

+ (DuoKanSessionInfo*) getSessionFromCookie {
    DuoKanSessionInfo* session = [[DuoKanSessionInfo alloc] init];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:duokanMainURL]];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"app_id"]) {
            session.appID = cookie.value;
        } else if ([cookie.name isEqualToString:@"user_id"]) {
            session.userID = cookie.value;
        } else if ([cookie.name isEqualToString:@"token"]) {
            session.token = cookie.value;
        } else if ([cookie.name isEqualToString:@"device_id"]) {
            session.deviceID = cookie.value;
        }
    }
    return session;
}

+ (void) getAllCookies {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:duokanMainURL]];
//    NSLog(@"Cookies: %@", cookies);
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"Cookie %@:%@ - %@", cookie.name, cookie.value, cookie.expiresDate);
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@", _userID, _appID, _deviceID, _token];
}

- (BOOL) isValid {
    if (_appID != nil
        && _userID != nil
        && _deviceID != nil
        && _token != nil) {
        return YES;
    }
    return NO;
}

@end
