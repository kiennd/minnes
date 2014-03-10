//
//  ImageViewController.h
//  MiniessSDK
//
//  Created by KienND on 3/8/14.
//  Copyright (c) 2014 molabo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (id) initWithImage:(UIImage *) image
             andData:(NSDictionary *)data;
@end
