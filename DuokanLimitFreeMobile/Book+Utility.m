//
//  Book+Utility.m
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-3.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//



#import "Book+Utility.h"


@implementation Book (Utility)

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@，原价%@", self.title, [self ratingString], self.oldPrice];
}

- (NSDictionary*) toDict {
    return @{@"title":self.title, @"price":self.price};
}

- (NSString*) thumbCover {
    return [NSString stringWithFormat:@"%@!e", self.cover];
}

- (NSString*) ratingString {
    switch (self.rating.intValue) {
        case 0:
            return @"零颗星";
            break;
        case 1:
            return @"半颗星";
            break;
        case 2:
            return @"一颗星";
            break;
        case 3:
            return @"一颗半星";
            break;
        case 4:
            return @"两颗星";
            break;
        case 5:
            return @"两颗半星";
            break;
        case 6:
            return @"三颗星";
            break;
        case 7:
            return @"三颗半星";
            break;
        case 8:
            return @"四颗星";
            break;
        case 9:
            return @"四颗半星";
            break;
        case 10:
            return @"五颗星";
            break;
        default:
            return @"零颗星";
            break;
    }
}

@end
