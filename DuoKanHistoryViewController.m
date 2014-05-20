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

@interface NSDate (DateDiff)
- (NSString*) diffTimeWithNow;
@end

@implementation NSDate (DateDiff)

- (NSString*) diffTimeWithNow {
    double ti = [self timeIntervalSinceDate:[NSDate date]];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else 	if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }	
}

@end

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
    [self.revealViewController revealToggle:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.revealViewController.frontViewPosition == FrontViewPositionRight) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
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
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Record";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DuoKanRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Record *record = [_fetchedResultsController objectAtIndexPath:indexPath];
    DuoKanRecordTableViewCell* recordCell = (DuoKanRecordTableViewCell*)cell;
    recordCell.bookTitle.text = record.book.title;
    recordCell.price.text = [NSString stringWithFormat:@"原价%@元", record.book.oldPrice];
    recordCell.record = record;
    if (![record.book isDuokanAppInstalled]) {
        recordCell.readButton.enabled = NO;
    } else {
        recordCell.readButton.enabled = YES;
    }
    [recordCell.cover setImageWithURL:[NSURL URLWithString:[record.book thumbCover]]
                   placeholderImage:[UIImage imageNamed:@"placeholder_for_book.png"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              image = [image scaleProportionalToSize:CGSizeMake(192,256)];
                              image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:image.imageOrientation];
                          }];
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
    return YES;
}

@end
