//
//  DuoKanWebViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-9.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanWebViewController.h"
#import "SWRevealViewController.h"

@implementation DuoKanWebViewController

@synthesize record;

- (void)viewDidLoad {
    NSString* url = record.book.url;
    NSLog(@"Loading web page: %@", url);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

-(void)handleSwipeGesture:(UIGestureRecognizer *) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action:(id)sender {
    // Display an action sheet for options
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Safari",
                            @"多看阅读",
                            @"拉入黑名单",
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

- (void)hideBook {
    DuoKanApi* api = [[DuoKanApi alloc] init];
    [api hide:record.book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self userInfo:nil];
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
                case 2:
                    [self hideBook];
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
