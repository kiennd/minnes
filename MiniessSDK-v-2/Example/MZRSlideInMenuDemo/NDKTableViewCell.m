//
//  NDKTableViewCell.m
//  MiniessSDK
//
//  Created by KienND on 3/11/14.
//  Copyright (c) 2014 molabo. All rights reserved.
//

#import "NDKTableViewCell.h"

@implementation NDKTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
