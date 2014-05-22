//
//  DuoKanHistoryViewController.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <SWTableViewCell.h>
#import "DuoKanApi.h"
#import "DuoKanDelegate.h"

@interface DuoKanHistoryViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, SWTableViewCellDelegate, DuoKanApiDelegate, DuokanDelegateCallback> {
//    IBOutlet UITableView* _tableView;
    IBOutlet UIBarButtonItem* _menuButton;
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)toggleTap:(id)sender;
- (void)refresh;

@end
