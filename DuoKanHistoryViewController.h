//
//  DuoKanHistoryViewController.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DuoKanHistoryViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
//    IBOutlet UITableView* _tableView;
    IBOutlet UIBarButtonItem* _menuButton;
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
