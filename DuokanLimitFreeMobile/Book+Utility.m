//
//  Book+Utility.m
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 14-4-3.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//



#import "Book+Utility.h"
#import "DuokanVariables.h"


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

- (NSString*) duokanAppURL {
    return [NSString stringWithFormat:@"duokan-reader://store/book/%@", self.bookID];
}

- (BOOL) isDuokanAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"duokan-reader://"]];
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

//{
//    ad = 0;
//    "ad_duration" = 5;
//    afs = "%e7%88%b1%e6%83%85%e9%9a%8f%e5%a0%82%e8%80%83";
//    authors = "\U767e\U5408\U5a5a\U604b\U7814\U7a76\U9662";
//    "book_id" = eedcee642f124e2a98bc6a78b4365c6d;
//    "comment_count" = 15;
//    cover = "http://cover.read.duokan.com/mfsv2/download/s010/p01ctEp9Ci1y/lAmdJeXDNPWv80.jpg!s";
//    editors = "";
//    "paper_price" = "29.8";
//    platforms = "iPhone\niPad\nAndroid\nKindle\nWeb";
//    price = 12;
//    quality = 90;
//    score = "3.6";
//    "score_count" = 21;
//    sid = 48057;
//    summary = "\U7ed9\U81ea\U5df1\U6765\U4e2a\U201c\U7231\U60c5\U968f\U5802\U8003\U201d\Uff0c\U604b\U7231\U987e\U95ee\U968f\U65f6\U5c31\U5728\U4f60\U8eab\U8fb9\Uff01";
//    title = "\U7231\U60c5\U968f\U5802\U8003";
//    updated = "2014-05-21";
//    webreader = 1;
//}

- (void) importJSON: (NSDictionary*) json {
    self.bookID = [json objectForKey:@"book_id"];
    self.author = [[json objectForKey:@"authors"] stringByReplacingOccurrencesOfString:@"\\\\n" withString:@", "];
    self.commentCount = [json objectForKey:@"comment_count"];
    self.price = [json objectForKey:@"price"];
    self.oldPrice = [json objectForKey:@"price"];
    self.cover = [[json objectForKey:@"cover"] stringByReplacingOccurrencesOfString:@"!s$" withString:@""];
    self.score = [json objectForKey:@"score"];
    self.rating = [NSNumber numberWithInteger:[self.score integerValue]];
    self.scoreCount = [json objectForKey:@"score_count"];
    self.summary = [json objectForKey:@"summary"];
    self.title = [json objectForKey:@"title"];
    self.sid = [json objectForKey:@"sid"];
    
    NSString* updateString = [json objectForKey:@"updated"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    self.updated = [dateFormatter dateFromString:updateString];
    
    self.url = [NSString stringWithFormat:@"%@%@", duokanMainURL, self.sid];
}

@end
