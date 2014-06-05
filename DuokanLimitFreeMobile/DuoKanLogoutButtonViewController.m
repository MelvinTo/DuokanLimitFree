//
//  DuoKanLogoutButtonViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-6-6.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanLogoutButtonViewController.h"
#import "SWRevealViewController.h"


@interface DuoKanLogoutButtonViewController ()

@end

@implementation DuoKanLogoutButtonViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"appeared, starting logout");
    [self logout];
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

- (void) logout {
    DuoKanApi* api = [[DuoKanApi alloc] init];
    [api logout:self];
}

- (void)logoutResult:(NSError *)err {
    if (err) {
        NSLog(@"met error when logging out: %@", [err localizedDescription]);
    } else {
        NSLog(@"Logout successfully, going back to login page");
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
    [DuoKanSessionInfo cleanCookies];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue is called");
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            NSLog(@"dvc is %@", dvc);
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            
            //            [dvc.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:dvc action:@selector(toggleReveal:)]];
            
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}

@end
