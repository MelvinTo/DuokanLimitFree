//
//  DuoKanMobileNotification.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-16.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book+Utility.h"

@interface DuoKanMobileNotification : NSObject

- (void) notifyBookOrdered: (Book*) book;

@end
