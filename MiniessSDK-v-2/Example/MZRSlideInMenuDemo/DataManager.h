//
//  DataManager.h
//  MiniessSDK
//
//  Created by KienND on 3/10/14.
//  Copyright (c) 2014 molabo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

// image
@property (strong,nonatomic) NSMutableArray* arrLikesThumbnail;
@property (strong,nonatomic) NSMutableArray* arrTrendingThumbnail;
@property (strong,nonatomic) NSMutableArray* arrPopularThumbnail;
@property (strong,nonatomic) NSMutableArray* arrRecentThumbnail;

// json data
@property (strong,nonatomic) NSMutableArray* likesData;
@property (strong,nonatomic) NSMutableArray* trendingData;
@property (strong,nonatomic) NSMutableArray* popularData;
@property (strong,nonatomic) NSMutableArray* recentData;



+ (id)sharedManager;
- (void) setDataWithAPI:(NSString*) currentAPI Data:(NSMutableArray*)data;
- (void) setImagesWithAPI:(NSString*) currentAPI ImageArray:(NSMutableArray*)data;
- (NSMutableArray*)getImagesWithAPI:(NSString*) currentAPI;
- (NSMutableArray*)getDataWithAPI:(NSString*) currentAPI;
@end
