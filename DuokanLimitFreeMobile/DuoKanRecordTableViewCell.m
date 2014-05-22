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

- (void)awakeFromNib
{
    // Initialization code
    NSLog(@"load from awakeFromNib");
    [self.readButton setTitle:@"得先安装多看App" forState:UIControlStateDisabled];
    [self.readButton setTitle:@"用多看App打开" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startReading:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.record.book.duokanAppURL]];
}

//- (void) disableReadButton {
//    self.readButton.enabled = NO;
//    [self.readButton setTitle:@"得先安装多看App" forState:NO];
//}

- (void)disableReadButton {
    
}

- (void) applyRecord: (Record*) record {
    self.bookTitle.text = record.book.title;
    self.price.text = [NSString stringWithFormat:@"原价%@元", record.book.oldPrice];
    self.record = record;
    self.orderTime.text = [NSString stringWithFormat:@"%@购买", [record.orderTime diffTimeWithNow]];

    if (![record.book isDuokanAppInstalled]) {
        self.readButton.enabled = NO;
    } else {
        self.readButton.enabled = YES;
    }
    [self.cover setImageWithURL:[NSURL URLWithString:[record.book thumbCover]]
                     placeholderImage:[UIImage imageNamed:@"placeholder_for_book.png"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                image = [image scaleProportionalToSize:CGSizeMake(192,256)];
                                image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:image.imageOrientation];
                            }];

}

@end
