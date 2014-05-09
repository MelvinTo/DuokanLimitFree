//
//  UIImage+Functions.h
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-8.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (UIImageFunctions)
- (UIImage *) scaleToSize: (CGSize)size;
- (UIImage *) scaleProportionalToSize: (CGSize)size;
@end