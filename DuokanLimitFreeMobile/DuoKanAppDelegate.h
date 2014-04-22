//
//  DuoKanAppDelegate.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-19.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuoKanDelegate.h"

typedef void (^BackgroundFetchHandler)(UIBackgroundFetchResult);

@interface DuoKanAppDelegate : UIResponder <UIApplicationDelegate, DuokanDelegateCallback> {
    BackgroundFetchHandler _handler;
    DuoKanDelegate* _duokanDelegate;
}

@property (strong, nonatomic) UIWindow *window;

@end
