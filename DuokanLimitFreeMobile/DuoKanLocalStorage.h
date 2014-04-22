//
//  DuoKanLocalStorage.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-4-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"


@interface DuoKanLocalStorage : NSObject {
    KeychainItemWrapper* _wrapper;
}

+ (DuoKanLocalStorage*) sharedStorage;

- (void) storeCredential: (NSString*) username withPassword: (NSString*) password;
- (NSString*) getUsername;
- (NSString*) getPassword;
- (void) clearCredential;

@end
