//
//  DataManager.m
//  MiniessSDK
//
//  Created by KienND on 3/10/14.
//  Copyright (c) 2014 molabo. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
//not direct call this funcition
- (id)init {
    if (self = [super init]) {
        _arrLikesThumbnail = [NSMutableArray new];
        _arrPopularThumbnail = [NSMutableArray new];
        _arrRecentThumbnail = [NSMutableArray new];
        _arrTrendingThumbnail = [NSMutableArray new];
        
        _likesData = [NSMutableArray new];
        _trendingData = [NSMutableArray new];
        _recentData = [NSMutableArray new];
        _popularData = [NSMutableArray new];
    }
    return self;
}


+ (id)sharedManager {
    static DataManager *sharedDataManager = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        sharedDataManager = [self new];
    });
    return sharedDataManager;
}

- (NSMutableArray*)getDataWithAPI:(NSString*) currentAPI
{
    NSMutableArray *oldData;
    if ([currentAPI isEqualToString:API_VIDEO_10]) {
        oldData = _likesData;
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        oldData = _popularData;
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        oldData = _recentData;
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        oldData = _trendingData;
    }
    return oldData;
}
- (NSMutableArray*)getImagesWithAPI:(NSString*) currentAPI
{
    NSMutableArray *oldData;
    if ([currentAPI isEqualToString:API_VIDEO_10]) {
        oldData = _arrLikesThumbnail;
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        oldData = _arrPopularThumbnail;
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        oldData = _arrRecentThumbnail;
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        oldData = _arrTrendingThumbnail;
    }
    return oldData;
}



- (void) setDataWithAPI:(NSString*) currentAPI Data:(NSMutableArray*)data
{
    if ([currentAPI isEqualToString:API_VIDEO_10]) {
        _likesData = data;
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        _popularData = data;
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        _recentData = data;
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        _trendingData = data;
    }
}
- (void) setImagesWithAPI:(NSString*) currentAPI ImageArray:(NSMutableArray*)data
{
    if ([currentAPI isEqualToString:API_VIDEO_10]) {
        _arrLikesThumbnail = data;
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        _arrPopularThumbnail = data;
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        _arrRecentThumbnail = data;
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        _arrTrendingThumbnail = data;
    }
}




@end
