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
        oldData = [[NSMutableArray alloc] initWithArray: _likesData];
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        oldData = [[NSMutableArray alloc] initWithArray: _popularData];
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        oldData = [[NSMutableArray alloc] initWithArray: _recentData];
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        oldData = [[NSMutableArray alloc] initWithArray: _trendingData];
    }
    return oldData;
}
- (NSMutableArray*)getImagesWithAPI:(NSString*) currentAPI
{
    NSMutableArray *oldData;
    if ([currentAPI isEqualToString:API_VIDEO_10]) {
        oldData = [[NSMutableArray alloc] initWithArray: _arrLikesThumbnail];
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        oldData = [[NSMutableArray alloc] initWithArray: _arrPopularThumbnail];
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        oldData = [[NSMutableArray alloc] initWithArray: _arrRecentThumbnail];
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        oldData = [[NSMutableArray alloc] initWithArray: _arrTrendingThumbnail];
    }
    return oldData;
}



- (void) setDataWithAPI:(NSString*) currentAPI Data:(NSMutableArray*)data
{
    if ([currentAPI isEqualToString:API_VIDEO_10]) {
        _likesData = [[NSMutableArray alloc] initWithArray: data];
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        _popularData = [[NSMutableArray alloc] initWithArray: data];
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        _recentData = [[NSMutableArray alloc] initWithArray: data];
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        _trendingData = [[NSMutableArray alloc] initWithArray: data];
    }
}
- (void) setImagesWithAPI:(NSString*) currentAPI ImageArray:(NSMutableArray*)data
{
    if ([currentAPI isEqualToString:API_VIDEO_10]) {
        _arrLikesThumbnail = [[NSMutableArray alloc] initWithArray: data];
    }else if([currentAPI isEqualToString:API_PopularVideo_10]){
        _arrPopularThumbnail = [[NSMutableArray alloc] initWithArray: data];
    }else if([currentAPI isEqualToString:API_RecentVideo_10]){
        _arrRecentThumbnail = [[NSMutableArray alloc] initWithArray: data];
    }else if([currentAPI isEqualToString:API_TrendingVideo_10]){
        _arrTrendingThumbnail = [[NSMutableArray alloc] initWithArray: data];
    }
}




@end
