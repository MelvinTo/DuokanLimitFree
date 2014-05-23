//
//  NSDate+Utility.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-22.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "NSDate+Utility.h"



@implementation NSDate (DateDiff)

- (NSString*) diffTimeWithNow {
    double ti = [self timeIntervalSinceDate:[NSDate date]];
    ti = ti * -1;
    if(ti < 1) {
        return @"刚刚";
    } else 	if (ti < 60) {
        return @"刚刚";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d分钟前", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d小时前", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d天前", diff];
    } else {
        return @"never";
    }
}

@end