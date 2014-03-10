//
//  ImageViewController.m
//  MiniessSDK
//
//  Created by KienND on 3/8/14.
//  Copyright (c) 2014 molabo. All rights reserved.
//

#import "ImageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ImageViewController ()
{
    
    UIImage *_image;
    NSDictionary* _data;
}
@property(strong, nonatomic) MPMoviePlayerController *player;
@property(strong, nonatomic) MPMoviePlayerViewController *videoPlayerView;
@property (weak, nonatomic) IBOutlet UILabel *lbUsername;
@property (weak, nonatomic) IBOutlet UILabel *lbNumOfLikes;
@property (weak, nonatomic) IBOutlet UILabel *lbImageTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbNumOfComments;
@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithImage:(UIImage *) image
             andData:(NSDictionary *)data {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _image = image;
        _data = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = _image;
    NSString* likes =[_data objectForKey:@"like"];
    if (![likes isKindOfClass:[NSNull class]]) {
        self.lbNumOfLikes.text = [_data objectForKey:@"like"];
    }else{
        self.lbNumOfLikes.text = @"0";
    }
    self.lbUsername.text = [_data objectForKey:@"username"];
    self.lbImageTitle.text = [_data objectForKey:@"post_title"];

    if (![[_data objectForKey:@"comments"] isKindOfClass:[NSNull class]]) {
        self.lbNumOfComments.text = [_data objectForKey:@"comments"];
    }else{
        self.lbNumOfComments.text = @"0";
    }
}


#pragma mark - Video Playing Methods.
-(void) playVideoForURL: (NSString *)strURLForVideo
{
    _videoPlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@%@",API_VIDEO_BASE_URL,strURLForVideo]]];
    _videoPlayerView.view.frame = CGRectMake(0, 420, 320, 148);
    [self.view addSubview:_videoPlayerView.view];
    
    //Set this if you wants to set full screen as size of your view.
    //[_videoPlayerView setWantsFullScreenLayout:NO];
    
    //Set this if you wants to see full page video.
    //[self presentMoviePlayerViewControllerAnimated:_videoPlayerView];
    
    //Set this if you wants to see complte video each time, means to remove options.
    // [_videoPlayerView.moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    [_videoPlayerView.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
    [_videoPlayerView.moviePlayer setFullscreen:FALSE];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(movieFinishedCallback:)
                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                              object:_player];
    
    [_videoPlayerView.moviePlayer play];
}

- (void) movieFinishedCallback:(NSNotification*)notification {
    
    MPMoviePlayerController *moviePlayer = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
        [moviePlayer.view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
