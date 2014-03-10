//
//  Constant.h
//  SampleDemoApp
//
//  Created by Modified by Miniess on 29/10/12.
//  Copyright (c) 2012 Modified by Miniess All rights reserved.
//
//************************************GLOBAL Constants*********************************
#pragma mark - GLOBAL Constants -

#define appDelegate (AppDelegate *) [[UIApplication sharedApplication] delegate];

#define globalSingletonManager [GlobalViewManager sharedManager];

//************************************GLOBAL Constants**********************************
#pragma mark - String White space removing method constants.

#define REMOVEWHITESPACE stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]


//*****************************************APIS*********************************************
#pragma mark - APIS -

#define API_BASE_URL @"http://developer.miniess.com"
#define API_VIDEO_10 @"/api/videos/recent_videos.json/stih9w3f8q4ieus2daow6jugwpen5ws5"
#define API_TrendingVideo_10 @"/api/videos/trending_video.json/stih9w3f8q4ieus2daow6jugwpen5ws5"
#define API_PopularVideo_10 @"/api/videos/popular_videos.json/stih9w3f8q4ieus2daow6jugwpen5ws5"
#define API_RecentVideo_10 @"/api/videos/recent_videos.json/stih9w3f8q4ieus2daow6jugwpen5ws5"
#define API_Single_Video @"/api/videos/videos.json/stih9w3f8q4ieus2daow6jugwpen5ws5/775"
#define API_Video_By_Tag @"/api/videos/video_by_tags.json/stih9w3f8q4ieus2daow6jugwpen5ws5/"

#define API_VIDEO_BASE_URL @"http://miniess.com/uploads/"

