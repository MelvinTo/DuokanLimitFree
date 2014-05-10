//
//  DuoKanLoginButtonViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-10.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanLoginButtonViewController.h"
#import "DuoKanSessionInfo.h"
#import "SWRevealViewController.h"


@interface DuoKanLoginButtonViewController ()

@end

@implementation DuoKanLoginButtonViewController

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
//    if ([self isLoggedIn]) {
//        [self performSegueWithIdentifier:@"main" sender:self];
//    }
    
    // Change button color
//    _menuButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

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

- (IBAction)clickLoginButton:(id)sender {
    NSLog(@"Start login");
    [self performSegueWithIdentifier:@"login" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (bool) isLoggedIn {
    DuoKanSessionInfo* info = [DuoKanSessionInfo getSessionFromCookie];
    if ([info isValid]) {
        return YES;
    }
    return NO;
}

@end
