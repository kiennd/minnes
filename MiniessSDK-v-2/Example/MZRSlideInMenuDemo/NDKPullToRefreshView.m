//
//  NDKPullToRefreshViewController.m
//  MiniessSDK
//
//  Created by KienND on 3/10/14.
//  Copyright (c) 2014 molabo. All rights reserved.
//

#import "NDKPullToRefreshView.h"

@interface NDKPullToRefreshView ()

@end

@implementation NDKPullToRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.0f]  CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
    
}

@end
