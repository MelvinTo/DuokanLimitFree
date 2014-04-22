//
//  DuoKanLoginViewController.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-19.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanLoginViewController.h"
#import "DuoKanLocalStorage.h"

static

@interface DuoKanLoginViewController ()

@end

@implementation DuoKanLoginViewController

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
    DuoKanLocalStorage* storage = [DuoKanLocalStorage sharedStorage];
    NSString* username = [storage getUsername];
    NSString* password = [storage getPassword];
    
    _usernameTF.text = username;
    _passwordTF.text = password;
    
    _usernameTF.delegate = self;
    _passwordTF.delegate = self;
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

- (void)loginResult:(DuoKanSessionInfo *)session withError:(NSError *)err {
    if (err == nil) {
        NSLog(@"Duokan login succeeded: %@", session);
        [_loginButton setTitle:@"登录成功" forState:UIControlStateDisabled];
    } else {
        NSLog(@"Failed to login: %@", [err localizedDescription]);
        [[DuoKanLocalStorage sharedStorage] clearCredential];
        [_loginButton setTitle:@"登录失败,点击重试" forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameTF) {
        [_passwordTF becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (void)login:(id)sender {
    
    NSString* username = [_usernameTF text];
    NSString* password = [_passwordTF text];
    
    [[DuoKanLocalStorage sharedStorage] storeCredential:username withPassword:password];

    DuoKanApi* api = [[DuoKanApi alloc] init];
    [api login:username withPassword:password withDelegate:self];
    
    [_loginButton setTitle:@"登录中" forState:UIControlStateDisabled];
    _loginButton.enabled = NO;
}

@end
