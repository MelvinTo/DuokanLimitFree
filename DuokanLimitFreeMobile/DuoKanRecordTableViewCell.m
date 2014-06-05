//
//  DuoKanRecordTableViewCell.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanRecordTableViewCell.h"
#import "UIImage+Functions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+Utility.h"
#import "SWRevealViewController.h"


@implementation DuoKanRecordTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"load from initWithStyle");
    }
    return self;
}

- (void)disableReadButton {
    
}

- (void)awakeFromNib
{
    // Initialization code
    NSLog(@"load from awakeFromNib");
    [self.readButton setTitle:@"安装多看" forState:UIControlStateDisabled];
    [self.readButton setTitle:@"阅读" forState:UIControlStateNormal];
    self.readButton.layer.borderColor = [UIColor blueColor].CGColor;
    [self.readButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startReading:(id)sender {
    if (![self.record.book isDuokanAppInstalled]) {
        NSLog(@"opening duokan app...");
        NSString *iTunesLink = @"http:////itunes.apple.com/cn/app/duo-kan-yue-du/id517850153";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.record.book.duokanAppURL]];
    }
}

- (void)setupRating {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:self.rate1];
    [array addObject:self.rate2];
    [array addObject:self.rate3];
    [array addObject:self.rate4];
    [array addObject:self.rate5];
    
    int rating = [self.record.book.rating intValue];
    int yellowCount = rating/2;
    int halfCount = rating%2;
    
    int i = 0;
    for (;i < yellowCount; i++) {
        UIImageView* view = (UIImageView*)(array[i]);
        [view setImage:[UIImage imageNamed:@"rating_yellow"]];
    }
    if (halfCount == 1) {
        UIImageView* view = (UIImageView*)(array[i]);
        [view setImage:[UIImage imageNamed:@"rating_half"]];
        i++;
    }
    for (; i < array.count; i++) {
        UIImageView* view = (UIImageView*)(array[i]);
        [view setImage:[UIImage imageNamed:@"rating_grey"]];
    }
    
}

- (void) applyRecord: (Record*) record {
    self.record = record;

    self.bookTitle.text = record.book.title;
    self.author.text = record.book.author;
    self.price.text = [NSString stringWithFormat:@"原价%@元", record.book.oldPrice];
    self.orderTime.text = [NSString stringWithFormat:@"%@购买", [record.orderTime diffTimeWithNow]];

    if (![record.book isDuokanAppInstalled]) {
        [self.readButton setTitle:@"安装多看" forState:UIControlStateNormal];
    } else {
        [self.readButton setTitle:@"阅读" forState:UIControlStateNormal];
    }

    [self.cover setImageWithURL:[NSURL URLWithString:[record.book thumbCover]]
                     placeholderImage:[UIImage imageNamed:@"placeholder_for_book.png"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                image = [image scaleProportionalToSize:CGSizeMake(192,256)];
                                image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:image.imageOrientation];
                            }];

    [self setupRating];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.tableViewController.revealViewController.frontViewPosition == FrontViewPositionRight) {
            return NO;
        }
    }
    return YES;
}

@end
