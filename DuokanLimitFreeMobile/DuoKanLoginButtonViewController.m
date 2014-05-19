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
    
    if ([self isLoggedIn]) {
        [self performSegueWithIdentifier:@"history" sender:self];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickLoginButton:(id)sender {
    NSLog(@"Start login");
    [self performSegueWithIdentifier:@"login" sender:self];
}

- (bool) isLoggedIn {
    DuoKanSessionInfo* info = [DuoKanSessionInfo getSessionFromCookie];
    if ([info isValid]) {
        return YES;
    }
    return NO;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue is called");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}

@end
