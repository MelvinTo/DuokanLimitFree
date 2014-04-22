//
//  DuoKanScheduler.m
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-6.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanScheduler.h"
#import "DuoKanApi.h"
#import "DuoKanDelegate.h"

static double timerInterval = 3600.0;

@implementation DuoKanScheduler

- (void) startSchedulingTimer {
    _delegate = [[DuoKanDelegate alloc]init];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:YES];
    [_delegate run];
}

- (void) stopTimer {
    
}

- (void)onTick:(NSTimer*)timer {
    NSLog(@"tick..");
    
    [_delegate run];
}

@end
