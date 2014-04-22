//
//  DuoKanApi.m
//  DuokanBuyLimitFree
//
//  Created by Melvin Tu on 13-7-8.
//  Copyright (c) 2013年 Melvin Tu. All rights reserved.
//

#import "DuoKanApi.h"
#import "AFNetworking.h"
#import "DuokanVariables.h"
#import "TFHpple.h"

@implementation DuoKanApi

- (void) login: (NSString*) username withPassword: (NSString*) password withDelegate: (id <DuoKanApiDelegate>) delegate {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{
                                 @"passToken": @"",
                                 @"user": username,
                                 @"pwd" : password,
                                 @"callback" : duokanLoginCallback,
                                 @"sid" : duokanLoginSid,
                                 @"qs" : duokanLoginQS,
                                 @"hidden" : @"",
                                 @"_sign" : duokanLoginSign
                                 };
    
    NSLog(@"calling url %@", duokanLoginURL);
//    NSLog(@"parameters: %@", parameters);
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

    [manager POST:duokanLoginURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Data: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        DuoKanSessionInfo* session = [DuoKanSessionInfo getSessionFromCookie];
        if ([session isValid]) {
            [delegate loginResult:[DuoKanSessionInfo getSessionFromCookie] withError:nil];
        } else {
            [delegate loginResult:nil withError:[NSError errorWithDomain:@"duokan" code:1 userInfo:@{@"cause" : @"credential incorrect"}]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Login Error: %@", error);
        [delegate loginResult:nil withError:error];
    }];
    
}

- (void) getMainPageWithDelegate: (id <DuoKanApiDelegate> ) delegate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"calling url %@", duokanMainURL);
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:duokanMainURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate mainPage:responseObject withError:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate mainPage:nil withError:error];
    }];
}



- (NSString*) getFreeBookURL: (NSData*) htmlData {
    TFHpple* doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray* elements = [doc searchWithXPathQuery:@"//li/a[@hidefocus='hidefocus']"];
    for (TFHppleElement* element in elements) {
        NSArray* children = [element childrenWithTagName:@"img"];
        for (TFHppleElement* child in children) {
            if ([[child objectForKey:@"alt"] isEqualToString:@"限时免费"]) {
//                NSLog(@"element: %@", element);
                return [NSString stringWithFormat:@"%@%@", duokanMainURL, [element objectForKey:@"href"]];
            }
        }
    }
    
    return nil;
}

- (DuoKanBook*) getBookInfo: (NSString*) url withDelegate:(id<DuoKanApiDelegate>)delegate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"calling url %@", duokanLoginURL);
    
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* htmlString = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
//        NSLog(@"Response: %@", htmlString);
        
        DuoKanBook* book = [self parseBookHTML:htmlString];
        [delegate bookInfo:book withError:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getBookInfo Error: %@", error);
    }];
    
    return nil;
}


- (NSString*) parseData: (NSString*) data withPattern: (NSString*) pattern {
    NSError *error = nil;
    __block NSString* matchString = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:data options:0 range:NSMakeRange(0, [data length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        matchString = [data substringWithRange:[match rangeAtIndex:1]];
        *stop = YES;
    }];
    return matchString;
}

- (NSNumber*) getRating: (NSString*) htmlString {
    NSData* data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple* doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray* elements = [doc searchWithXPathQuery:@"//div[@class='desc']/div[@class='u-stargrade']"];
    for (TFHppleElement* element in elements) {
        NSArray* children = [element childrenWithTagName:@"div"];
        for (TFHppleElement* child in children) {
            id classValue = [child objectForKey:@"class"];
            if ([classValue isKindOfClass:[NSString class]]) {
                NSString* rateString = (NSString*) classValue;
                NSInteger rate = [[rateString substringFromIndex:10] integerValue];
                NSLog(@"rateString: %ld", (long)rate);
                return [NSNumber numberWithInteger:rate];
            }
        }
    }
    return nil;
}

- (DuoKanBook*) parseBookHTML: (NSString*) htmlString {
    
    DuoKanBook* book = nil;
    NSString* jsonString = [self parseData:htmlString withPattern:@"(window.dk_data = \\{[^\\}]+book : \\{[^\\}]+\\})[^\\}]*\\}"];
    
    book = [[DuoKanBook alloc] init];
    book.title = [self parseData:jsonString withPattern:@"title : '([^']*)'"];
    book.ID = [self parseData:jsonString withPattern:@"book_id : '([^']*)'"];
    book.price = [self parseData:jsonString withPattern:@"price : '([^']*)'"];
    book.oldPrice = [self parseData:jsonString withPattern:@"old_price : '([^']*)'"];
    book.cover = [self parseData:jsonString withPattern:@"cover : '([^']*)'"];
    book.url = [NSString stringWithFormat:@"%@%@", duokanMainURL, [self parseData:jsonString withPattern:@"url : '([^']*)'"]];
    book.author = [self parseData:jsonString withPattern:@"authors : '([^']*)'"];

    // get rating
    book.rating = [self getRating:htmlString];
    
    return book;

}

- (void) isOrdered: (DuoKanBook*) book inSession: (DuoKanSessionInfo*) session withDelegate:(id<DuoKanApiDelegate>)delegate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"calling url %@", duokanCheckURL);
    
    NSDictionary *parameters = @{
                                 @"book_uuid": book.ID,
                                 @"token": session.token,
                                 @"user_id": session.userID,
                                 @"app_id": session.appID,
                                 @"device_id": session.deviceID
                                 };
//    NSLog(@"parameters: %@", parameters);

    [manager POST:duokanCheckURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dict = (NSDictionary*)responseObject;
            NSNumber* result = [dict objectForKey:@"result"];
            NSString* msg = [dict objectForKey:@"msg"];
            
            if([result isEqual:[NSNumber numberWithInt:0]] && [msg isEqualToString:@"成功"]) {
                NSLog(@"Book [%@] is already ordered", book);
                [delegate isOrdered:YES forBook: book withError:nil];
                return;
            }
            
        }
        NSLog(@"check response: %@", responseObject);
        [delegate isOrdered:NO forBook: book withError:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error when calling isOrdered: %@", error);
    }];
}

- (void) order: (DuoKanBook*) book inSession: (DuoKanSessionInfo*) session withDelegate: (id<DuoKanApiDelegate>) delegate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"calling url %@", duokanOrderURL);
    
    NSDictionary *parameters = @{
                                 @"book_uuid": book.ID,
                                 @"token": session.token,
                                 @"user_id": session.userID,
                                 @"app_id": session.appID,
                                 @"device_id": session.deviceID
                                 };
//    NSLog(@"parameters: %@", parameters);
    
    [manager POST:duokanOrderURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dict = (NSDictionary*)responseObject;
            NSNumber* result = [dict objectForKey:@"result"];
            NSString* msg = [dict objectForKey:@"msg"];
            
            if([result isEqual:[NSNumber numberWithInt:0]] && [msg isEqualToString:@"成功"]) {
                NSLog(@"Succesfully ordered book: %@", book);
                [delegate orderResult:YES forBook: book withError:nil];
                return;
            }
            
        }
//        NSLog(@"check response: %@", responseObject);
        [delegate orderResult:NO forBook: book withError:[NSError errorWithDomain:@"failed to order" code:1 userInfo:@{@"response": responseObject}]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error when calling order: %@", error);
        [delegate orderResult:NO forBook:book withError:error];
    }];
}



@end
