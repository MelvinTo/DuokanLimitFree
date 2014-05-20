//
//  DuoKanRecordTableViewCell.m
//  DuokanLimitFreeMobile
//
//  Created by Melvin Tu on 14-5-20.
//  Copyright (c) 2014年 Melvin Tu. All rights reserved.
//

#import "DuoKanRecordTableViewCell.h"

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

@end
