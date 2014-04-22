//
//  DuoKanDelegate.h
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-5.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuoKanApi.h"
#import "DuoKanMobileNotification.h"

@protocol DuokanDelegateCallback <NSObject>

- (void) DuokanDelegate: (id) delegate success: (DuoKanBook*) book;
- (void) DuokanDelegate:(id)delegate failure:(DuoKanBook *)book withError: (NSError*) err;

@end

@interface DuoKanDelegate : NSObject<DuoKanApiDelegate> {
    DuoKanApi* _api;
    DuoKanMobileNotification* _notification;
    id<DuokanDelegateCallback> _callback;
}

- (void) run;
- (void) setCallback: (id<DuokanDelegateCallback>) callback;

@end
