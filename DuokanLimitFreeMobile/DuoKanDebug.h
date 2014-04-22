//
//  DuoKanDebug.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-21.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DuoKanDebugDelegate <NSObject>

- (void) foundDebugLog: (NSString*) log;

@end

@interface DuoKanDebug : NSObject {
    NSMutableSet* _set;
}

+ (DuoKanDebug*) sharedDebugger;

- (void) produceDebugLog: (NSString*) log;
- (void) registerDelegate: (id<DuoKanDebugDelegate>) delegate;
- (void) unregisterDelegate: (id<DuoKanDebugDelegate>) delegate;

@end
