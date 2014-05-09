//
//  DuoKanWebViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-9.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanWebViewController.h"

@implementation DuoKanWebViewController

@synthesize record;

- (void)viewDidLoad {
    NSString* url = record.book.url;
    NSLog(@"Loading web page: %@", url);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
@end
