//
//  DuoKanNavigationController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-11.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanNavigationController.h"
#import "DuoKanSessionInfo.h"
#import "DuoKanLoginButtonViewController.h"


@interface DuoKanNavigationController ()

@end

@implementation DuoKanNavigationController

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
    NSLog(@"DuoKanNavigationController is loaded");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue...");
}

- (bool) isLoggedIn {
    DuoKanSessionInfo* info = [DuoKanSessionInfo getSessionFromCookie];
    if ([info isValid]) {
        return YES;
    }
    return NO;
}

@end
