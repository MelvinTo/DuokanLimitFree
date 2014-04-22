//
//  DuoKanDebug.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-21.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanDebug.h"

@implementation DuoKanDebug

+ (DuoKanDebug *)sharedDebugger {
    static DuoKanDebug* shared = nil;
    
    @synchronized(shared) {
        if(shared == nil) {
            shared = [[DuoKanDebug alloc] init];
        }
    }
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _set = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)produceDebugLog:(NSString *)log {
    for (id<DuoKanDebugDelegate> delegate in _set) {
        [delegate foundDebugLog:log];
    }
}

- (void) registerDelegate: (id<DuoKanDebugDelegate>) delegate {
    [_set addObject:delegate];
}

- (void) unregisterDelegate: (id<DuoKanDebugDelegate>) delegate {
    if ([_set containsObject:delegate]) {
        [_set removeObject:delegate];
    }
}

@end
