//
//  DuoKanDebugViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanDebugViewController.h"
#import "Book+Utility.h"
#import "DuoKanMobileNotification.h"
#import "DuokanDelegate.h"

@interface DuoKanDebugViewController ()

@end

@implementation DuoKanDebugViewController

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
    [[DuoKanDebug sharedDebugger] registerDelegate:self];
    NSString* text = [[NSUserDefaults standardUserDefaults] objectForKey:@"debug_log"];
    _textView.text = text;
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

- (IBAction)triggerNotification:(id)sender {
    Book* book = [[Book alloc] init];
    book.title = @"三国演义";
    book.price = [NSNumber numberWithFloat:6.0];
    book.oldPrice = [NSNumber numberWithFloat:12.0];
    book.bookID = @"123455";
    book.rating = [NSNumber numberWithInt:8];
    
    DuoKanMobileNotification* notif = [[DuoKanMobileNotification alloc] init];
    [notif notifyBookOrdered:book];
}

- (IBAction)testCheckNewFreeLimit:(id)sender {
    DuoKanDelegate* delegate = [[DuoKanDelegate alloc] init];
    [delegate run];
}

- (void)foundDebugLog:(NSString *)log {
    NSString* newText = [NSString stringWithFormat:@"%@\n%@ - %@", _textView.text, [NSDate date], log];
    [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"debug_log"];
    _textView.text = newText;
}

@end
