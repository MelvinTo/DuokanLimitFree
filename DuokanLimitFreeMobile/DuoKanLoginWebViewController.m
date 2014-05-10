//
//  DuoKanLoginWebViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-10.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanLoginWebViewController.h"

static NSString* loginURL = @"https://account.xiaomi.com/pass/serviceLogin?callback=http%3A%2F%2Flogin.dushu.xiaomi.com%2Fdk_id%2Fapi%2Fcheckin%3Ffollowup%3Dhttp%253A%252F%252Fwww.duokan.com%252Fm%252F%253Fapp_id%253Dweb%26sign%3DNGY2MTUyNTM2NWVmNWQzOTA5NmZlZGYwYzM2NDEzZmM%3D&sid=dushu&display=mobile";

@interface DuoKanLoginWebViewController ()

@end

@implementation DuoKanLoginWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loginURL]]];
    [_webView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* urlString = [request.URL absoluteString];
    NSLog(@"Start loading page: %@", urlString);
    if ([urlString isEqualToString:@"http://www.duokan.com/m/"]) {
        NSLog(@"login successfully!!");
        return NO;
    }
//    if (request.URL.) {
//        <#statements#>
//    }
    return YES;
}

@end
