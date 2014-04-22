//
//  DuoKanLocalStorage.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanLocalStorage.h"
#import "KeychainItemWrapper.h"

static NSString* kDuokanUsername = @"duokan_username";
static NSString* kDuokanPassword = @"duokan_password";

@implementation DuoKanLocalStorage

+ (DuoKanLocalStorage*) sharedStorage {
    static DuoKanLocalStorage* _shared = nil;
    
    @synchronized(_shared) {
        if (_shared == nil) {
            _shared = [[DuoKanLocalStorage alloc] init];
        }
    }

    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"DuokanLoginData" accessGroup:nil];
    }
    return self;
}

- (void) storeCredential: (NSString*) username withPassword: (NSString*) password {
    [_wrapper setObject:username forKey:(__bridge id)kSecAttrAccount];
    [_wrapper setObject:password forKey:(__bridge id)kSecValueData];
    
}

- (NSString*) getUsername {
    NSString *username = [_wrapper objectForKey:(__bridge id)kSecAttrAccount];
    return username;
}

- (NSString*) getPassword {
    NSString *password = [_wrapper objectForKey:(__bridge id)kSecValueData];
    return password;
}

- (void) clearCredential {
    [_wrapper setObject:nil forKey:(id)kDuokanUsername];
    [_wrapper setObject:nil forKey:(id)kDuokanPassword];
}

@end
