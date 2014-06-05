//
//  DuoKanHistoryViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanHistoryViewController.h"
#import "DuoKanCoreDataUtil.h"
#import "UIImage+Functions.h"
#import "DuoKanWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SWRevealViewController.h"
#import "DuoKanRecordTableViewCell.h"

@implementation DuoKanHistoryViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (bool) isTapGestureAdded {
    NSArray* list = [self.view gestureRecognizers];
    for (UIGestureRecognizer* recognizer in list) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            return YES;
        }
    }
    return NO;
}

- (UITapGestureRecognizer*)getTapGesture {
    NSArray* list = [self.view gestureRecognizers];
    for (UIGestureRecognizer* recognizer in list) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            return (UITapGestureRecognizer*)recognizer;
        }
    }
    return nil;
}

- (void) toggleTap:(id) sender {
    NSLog(@"called toggleTap");
    [self.revealViewController revealToggle:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    self.navigationItem.backBarButtonItem = _menuButton;
    
    // Set the gesture
    NSLog(@"viewDidLoad for %@", self.class);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(toggleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap setDelegate:self];
    [self.view addGestureRecognizer: tap];
    
    NSLog(@"history view is loaded");
    self.title = @"抢书记录";
    self.managedObjectContext = [[DuoKanCoreDataUtil sharedUtility] managedObjectContext];

    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)refresh {
    DuoKanDelegate* delegate = [[DuoKanDelegate alloc] init];
    [delegate setCallback:self];
    [delegate run];
}

- (void)DuokanDelegate:(id)delegate failure:(Book *)book withError:(NSError *)err {
    NSLog(@"DuokanDelegate failure is called");
    [self.refreshControl endRefreshing];
}

- (void)DuokanDelegate:(id)delegate success:(Book *)book {
    NSLog(@"DuokanDelegate success is called");
    [self.refreshControl endRefreshing];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        if (self.navigationController.viewControllers.count == 1) { //关闭主界面的右滑返回
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
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


- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"orderTime" ascending:NO]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"book.hide == %@ or book.hide == nil", [NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:predicate];

    
    NSLog(@"managedObjectContext for history: %@", [self managedObjectContext]);
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    NSUInteger count =  [sectionInfo numberOfObjects];
    NSLog(@"numberOfRowsInSection: %ld", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Record";
    
    DuoKanRecordTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DuoKanRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.tableViewController = self;

    
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DuoKanRecordTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Record *record = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell applyRecord:record];
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"will change content...");
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
                didChangeObject:(id)anObject
                atIndexPath:(NSIndexPath *)indexPath
                forChangeType:(NSFetchedResultsChangeType)type
                newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"didChangeObject is called");
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

//
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"didChangeSection is called");
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
//
//

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"controllerDidChangeContent is called");
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 168.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"cell %@ is selected", indexPath);
    Record *record = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"web" sender:record];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"web"] && [sender isKindOfClass:[Record class]]) {
        NSLog(@"call segue web from %@", sender);
        DuoKanWebViewController* controller = [segue destinationViewController];
        controller.record = (Record*) sender;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"web"] && ! [sender isKindOfClass:[Record class]]) {
        return NO;
    }
    
    if ([identifier isEqualToString:@"web"] && self.revealViewController.frontViewPosition == FrontViewPositionRight) {
        return NO;
    }
    return YES;
}

-(void)swipeableTableViewCell:(DuoKanRecordTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)swipeableTableViewCell:(DuoKanRecordTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        NSLog(@"隐藏按钮被点击");
        DuoKanApi* api = [[DuoKanApi alloc] init];
        [api hide:cell.record.book inSession:[DuoKanSessionInfo getSessionFromCookie] withDelegate:self userInfo:@{@"cell":cell}];
    }
}

- (void)hideResult:(Book *)book withError:(NSError *)err userInfo:(NSDictionary *)info {
    if (err == nil) {
        NSLog(@"Book %@ is successfully hided", book);
        book.hide = [NSNumber numberWithBool:YES];
        [[DuoKanCoreDataUtil sharedUtility] deleteRecord:book.record];
        [[DuoKanCoreDataUtil sharedUtility] save];
        NSLog(@"number of records: %ld", [[[DuoKanCoreDataUtil sharedUtility] getAllVisibleRecords] count]);
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    return leftUtilityButtons;
}

- (void)dealloc {
    NSLog(@"dealloc is called for HistoryViewController: %@", self);
    for (UIGestureRecognizer* recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
}

@end
