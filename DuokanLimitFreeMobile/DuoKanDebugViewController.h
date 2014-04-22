//
//  DuoKanDebugViewController.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuoKanDebug.h"

@interface DuoKanDebugViewController : UIViewController<DuoKanDebugDelegate> {
    IBOutlet UITextView* _textView;
}

- (IBAction)triggerNotification:(id)sender;
- (IBAction)testCheckNewFreeLimit:(id)sender;

@end
