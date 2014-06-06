//
//  DuoKanWebViewController.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-9.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record+Utility.h"
#import "DuoKanApi.h"

@interface DuoKanWebViewController : UIViewController<UIActionSheetDelegate, DuoKanApiDelegate> {
    IBOutlet UIWebView* _webView;
}

@property (nonatomic, strong) Record* record;

- (IBAction)action:(id)sender;

@end
