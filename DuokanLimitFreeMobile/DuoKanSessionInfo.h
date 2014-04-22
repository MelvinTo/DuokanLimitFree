//
//  DuoKanSessionInfo.h
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 13-7-8.
//  Copyright (c) 2013年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuokanVariables.h"


@interface DuoKanSessionInfo : NSObject {
    NSString* _token;
    NSString* _userID;
    NSString* _appID;
    NSString* _deviceID;
}

@property (nonatomic) NSString* token;
@property (nonatomic) NSString* userID;
@property (nonatomic) NSString* appID;
@property (nonatomic) NSString* deviceID;

+ (DuoKanSessionInfo*) getSessionFromCookie;
+ (void) getAllCookies;

- (BOOL) isValid;

@end
