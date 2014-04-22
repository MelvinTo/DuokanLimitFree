//
//  DuoKanLoginViewController.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-19.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuoKanApi.h"

@interface DuoKanLoginViewController : UIViewController<DuoKanApiDelegate,UITextFieldDelegate> {
    IBOutlet UITextField* _usernameTF;
    IBOutlet UITextField* _passwordTF;
    IBOutlet UIButton* _loginButton;
}

- (IBAction)login:(id)sender;

@end
