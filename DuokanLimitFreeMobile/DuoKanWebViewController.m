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

- (IBAction)action:(id)sender {
    // Display an action sheet for options
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Safari",
                            @"多看阅读",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)openWithSafari {
    NSLog(@"action is clicked, opening book in safari: %@", record.book);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:record.book.url]];
}

- (void)openWithDuokanApp {
    NSLog(@"action is clicked, opening book in duokan: %@", record.book);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:record.book.duokanAppURL]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self openWithSafari];
                    break;
                case 1:
                    [self openWithDuokanApp];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

@end
