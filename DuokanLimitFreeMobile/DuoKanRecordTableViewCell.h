//
//  DuoKanRecordTableViewCell.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"
#import <SWTableViewCell.h>

@interface DuoKanRecordTableViewCell : SWTableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UILabel* bookTitle;
@property (nonatomic, weak) IBOutlet UILabel* author;
@property (nonatomic, weak) IBOutlet UILabel* price;
@property (nonatomic, weak) IBOutlet UIImageView* cover;
@property (nonatomic, weak) IBOutlet UIImageView* rate1;
@property (nonatomic, weak) IBOutlet UIImageView* rate2;
@property (nonatomic, weak) IBOutlet UIImageView* rate3;
@property (nonatomic, weak) IBOutlet UIImageView* rate4;
@property (nonatomic, weak) IBOutlet UIImageView* rate5;
@property (nonatomic, weak) IBOutlet UIButton* readButton;
@property (nonatomic, weak) IBOutlet UILabel* orderTime;
@property (nonatomic, weak) Record* record;
@property (nonatomic, strong) UITableViewController* tableViewController;

- (IBAction) startReading:(id)sender;
- (void) disableReadButton;
- (void) applyRecord: (Record*) record;

@end
