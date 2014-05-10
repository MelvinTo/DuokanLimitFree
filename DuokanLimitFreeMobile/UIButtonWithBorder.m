//
//  UIButtonWithBorder.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-10.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "UIButtonWithBorder.h"

@implementation UIButtonWithBorder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
