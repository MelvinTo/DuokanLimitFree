//
//  DuoKanMobileNotification.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-16.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanMobileNotification.h"

@implementation DuoKanMobileNotification

- (void) notifyBookOrdered: (Book*) book {
    
    if(book == nil) {
        return;
    }
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif) {
        localNotif.alertBody = [NSString stringWithFormat:
                                NSLocalizedString(@"抢到限免书: %@", nil), book];
        localNotif.alertAction = NSLocalizedString(@"打开", nil);
        localNotif.soundName = @"alarmsound.caf";
        localNotif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
    
}


@end
