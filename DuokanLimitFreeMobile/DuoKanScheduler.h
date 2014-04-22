//
//  DuoKanScheduler.h
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-6.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuoKanDelegate.h"

@interface DuoKanScheduler : NSObject {
    NSTimer* _timer;
    DuoKanDelegate* _delegate;
}

@property (atomic, strong) NSTimer* timer;

- (void) startSchedulingTimer;
- (void) stopTimer;

@end
