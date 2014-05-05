//
//  Book+Utility.h
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-3.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface Book (Utility)

- (NSDictionary*) toDict;
- (NSString*) ratingString;

@end
