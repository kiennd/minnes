//
//  ViewController.m
//  MZRSlideInMenuDemo
//
//  Created by Contributed By Miniess on 2014/01/25.
//  Copyright (c) Modified by Miniess All rights reserved.
//

#import "ViewController.h"

#import <MZRSlideInMenu.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageViewController.h"
#import "DataManager.h"
#import "NDKPullToRefreshView.h"
static NSString *const kButtonTitle0 = @"Likes";
static NSString *const kButtonTitle1 = @"Trending";
static NSString *const kButtonTitle2 = @"Popular";
static NSString *const kButtonTitle3 = @"Recent";
static NSString *const kButtonTitle4 = @" My Profile";
static NSString *const kButtonTitle5 = @"Settings";

@interface ViewController ()<MZRSlideInMenuDelegate>
{
    __weak IBOutlet UIButton *btnFromRight;
    __weak IBOutlet UIButton *btnFromLeft;
    __weak IBOutlet UIButton *btnFromLeftColorful;
    __weak IBOutlet UIButton *btnFromRightColorful;
    
    NSMutableArray* arrayImage;
    
    //Variable created and used by us.
    int intRepeatCounter; // Use this variable, to call API 3-times if sessions ends.
    NSMutableArray *aryMThumnails, *aryMTrendingVideos, *aryMPopularVideos;//Arrary of different data respectively.
    NSMutableArray *aryMMetaDataOfRecent10;//array of Complete Raw json comes from server while API hit's each time.
    NSMutableArray *aryMOfImages;//array of images , so no need to reload from server each time or save it in memory, just to hold and use each time.
    NSMutableArray *aryImageInfo;
    IBOutlet UITableView *tblThumnails; //Table showing thumbnails.
    NSString *strAPICallName;// Contains name of which API is calling,
}

//Variable of MoviePlayerController , to play video URL's.
@property(strong, nonatomic) MPMoviePlayerController *player;
@property(strong, nonatomic) MPMoviePlayerViewController *videoPlayerView;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (strong,nonatomic) NSString * currentAPI;
@property (nonatomic, strong) UIView *loadingView;
@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Allocate mutable arrays.
    aryMThumnails = [[NSMutableArray alloc] init];
    aryMTrendingVideos = [[NSMutableArray alloc] init];
    aryMMetaDataOfRecent10 = [[NSMutableArray alloc] init];
    aryMOfImages = [[NSMutableArray alloc] init];
    aryImageInfo = [[NSMutableArray alloc] init];
    arrayImage = [NSMutableArray new];
    
    //set default API name as @"".
    strAPICallName = @"";
    
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:tblThumnails delegate:self];
    self.pullToRefreshView.contentView = [[NDKPullToRefreshView alloc] initWithFrame:CGRectZero];
    
}


#pragma mark - UI animation Methonds.


- (IBAction)fromLeftColorfulButtonTapped:(UIButton *)sender
{
    MZRSlideInMenu *menu = [[MZRSlideInMenu alloc] init];
    [menu setDelegate:self];
    [menu addMenuItemWithTitle:kButtonTitle0 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]];
    [menu addMenuItemWithTitle:kButtonTitle1 textColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
    [menu addMenuItemWithTitle:kButtonTitle2 textColor:[UIColor colorWithWhite:0.7 alpha:1.0] backgroundColor:[UIColor yellowColor]];
    [menu addMenuItemWithTitle:kButtonTitle3 textColor:[UIColor whiteColor] backgroundColor:[UIColor purpleColor]];
    [menu addMenuItemWithTitle:kButtonTitle4 textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
    [menu showMenuFromLeft];
}

#pragma mark - Methods to call API of button selection basis.
/**
 *  For call respective API on basis on button click.
 *	@return: index as, identity of selected button.
 */
- (void)slideInMenu:(MZRSlideInMenu *)menuView didSelectAtIndex:(NSUInteger)index
{
    
    switch (index) {
        case 0:
            strAPICallName = @"Photos";
            [self callAPIForThumbnail];
            break;
            
        case 1:
            strAPICallName = @"Trending Videos";
            [self callAPIForTrendVideo];
            break;
            
        case 2:
            strAPICallName = @"Popular Videos";
            [self callAPIForPopularVideo];
            break;
            
        case 3:
            strAPICallName = @"Recent Videos";
            [self callAPIForRecentVideo];
            break;
            
        case 4:
            strAPICallName = @"";
            [self callSingleViewVideo];
            break;
            
        default:
            break;
    }
}




#pragma mark - API Calling Methods.
/**
 *  API to fetch Thumbnail from server.
 */
-(void)callAPIForThumbnail
{
    [self fetchThumbnailsFromServer:API_VIDEO_10 Limit:16];
    
}


/**
 *  API to fetch TrendingVideoURL's from server.
 */
-(void)callAPIForTrendVideo
{
    [self fetchThumbnailsFromServer:API_TrendingVideo_10 Limit:10];
}


/**
 *  API to fetch PopularVideoURL's from server.
 */
-(void)callAPIForPopularVideo
{
    [self fetchThumbnailsFromServer:API_PopularVideo_10 Limit:10];
}


/**
 *  API to fetch RecentVideoURL's from server.
 */
-(void)callAPIForRecentVideo
{
    [self fetchThumbnailsFromServer:API_RecentVideo_10 Limit:10];
}


/**
 *  API to fetch singleVideoURL from server.
 */
-(void)callSingleViewVideo
{
    [self fetchSingleVideoFromServer];
}


#pragma mark - Data Fetching AFNetworking Methods.
-(void) fetchThumbnailsFromServer:(NSString*) apiString Limit:(int) limit
{
    //Preparing Parameter Dictionary to pass in API.
    [self showLoading];
    NSDictionary *paramSurveyAll = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSString stringWithFormat:@"%d",limit], @"limit",
                                    nil];
    _currentAPI = apiString;
    
    NSURL *urlBase = [NSURL URLWithString:API_BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlBase];
    
    //Default setting.
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    
    //Set Request.
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:apiString parameters:paramSurveyAll];
    [request setTimeoutInterval:240];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             if(JSON !=NULL && [JSON isKindOfClass:[NSArray class]])
                                             {
                                                 intRepeatCounter = 0;
                                                 
                                                 [aryMMetaDataOfRecent10 removeAllObjects];
                                                 [aryImageInfo removeAllObjects];
                                                 //Parse Data
                                                 for(id objAry in JSON)
                                                 {
                                                     NSMutableDictionary *dictOfAData = (NSMutableDictionary *)objAry;
                                                     [aryMMetaDataOfRecent10 addObject:[dictOfAData objectForKey:@"meta_value"]];
                                                     [aryImageInfo addObject:dictOfAData];
                                                 }
                                                 
                                                 //Call methods to fetch thumnails from Parent Dictionary.
                                                 [self parseThumnails];
                                             }
                                             else
                                             {
                                                 NSLog(@"Req JSON - %@",JSON);
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             
                                             intRepeatCounter = intRepeatCounter + 1;
                                             
                                             if(intRepeatCounter < 3)
                                             {
                                                 [self fetchThumbnailsFromServer:apiString Limit:limit];
                                             }
                                             else
                                             {
                                                 intRepeatCounter = 0;
                                                 NSLog(@" Error - %@",error);
                                                 [self removeLoading];
                                             }
                                             
                                         }];
    [operation start];
    [operation waitUntilFinished];
}


/**
 *  For fetching TrendingVideos from server.
 */
//-(void) fetchTrendingVideosFromServer
//{
//    //Preparing Parameter Dictionary to pass in API.
//    NSDictionary *paramSurveyAll = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @"10", @"limit",
//                                    nil];
//    
//    
//    NSURL *urlBase = [NSURL URLWithString:API_BASE_URL];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlBase];
//    
//    //Default setting.
//    httpClient.parameterEncoding = AFJSONParameterEncoding;
//    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
//    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    
//    
//    //Set Request.
//    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:API_TrendingVideo_10 parameters:paramSurveyAll];
//    [request setTimeoutInterval:240];
//    
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//                                         {
//                                             if(JSON !=NULL && [JSON isKindOfClass:[NSArray class]])
//                                             {
//                                                 intRepeatCounter = 0;
//                                                 
//                                                 [aryMMetaDataOfRecent10 removeAllObjects];
//                                                 for(id objAry in JSON)
//                                                 {
//                                                     NSMutableDictionary *dictOfAData = (NSMutableDictionary *)objAry;
//                                                     [aryMMetaDataOfRecent10 addObject:[dictOfAData objectForKey:@"meta_value"]];
//                                                 }
//
//                                                 //Call methods to fetch thumnails from Parent Dictionary.
//                                                 [self parseThumnails];
//                                                 
//                                             }
//                                             else
//                                             {
//                                                 NSLog(@"Req JSON - %@",JSON);
//                                             }
//                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                             
//                                             intRepeatCounter = intRepeatCounter + 1;
//                                             
//                                             if(intRepeatCounter < 3)
//                                             {
//                                                 [self fetchTrendingVideosFromServer];
//                                             }
//                                             else
//                                             {
//                                                 intRepeatCounter = 0;
//                                                 
//                                                 NSLog(@" Error - %@",error);
//                                             }
//                                         }];
//    
//    [operation start];
//    [operation waitUntilFinished];
//}
//
//
///**
// *  For fetching PopularVideos from server.
// */
//-(void) fetchPopularVideosFromServer
//{
//    //Preparing Parameter Dictionary to pass in API.
//    NSDictionary *paramSurveyAll = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @"15", @"limit",
//                                    nil];
//    
//    
//    NSURL *urlBase = [NSURL URLWithString:API_BASE_URL];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlBase];
//    
//    //Default setting.
//    httpClient.parameterEncoding = AFJSONParameterEncoding;
//    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
//    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    
//    
//    //Set Request.
//    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:API_PopularVideo_10 parameters:paramSurveyAll];
//    [request setTimeoutInterval:240];
//    
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//                                         {
//                                             if(JSON !=NULL && [JSON isKindOfClass:[NSArray class]])
//                                             {
//                                                 intRepeatCounter = 0;
//                                                 
//                                                 [aryMMetaDataOfRecent10 removeAllObjects];
//                                                 for(id objAry in JSON)
//                                                 {
//                                                     NSMutableDictionary *dictOfAData = (NSMutableDictionary *)objAry;
//                                                     [aryMMetaDataOfRecent10 addObject:[dictOfAData objectForKey:@"meta_value"]];
//                                                 }
//                                               
//                                                 //Call methods to fetch thumnails from Parent Dictionary.
//                                                 [self parseThumnails];
//                                             }
//                                             else
//                                             {
//                                                 NSLog(@"Req JSON - %@",JSON);
//                                             }
//                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                             
//                                             intRepeatCounter = intRepeatCounter + 1;
//                                             
//                                             if(intRepeatCounter < 3)
//                                             {
//                                                 [self fetchPopularVideosFromServer];
//                                             }
//                                             else
//                                             {
//                                                 intRepeatCounter = 0;
//                                                 
//                                                 NSLog(@" Error - %@",error);
//                                             }
//                                         }];
//    
//    [operation start];
//    [operation waitUntilFinished];
//}
//
//
///**
// *  For fetching RecentVideos from server.
// */
//-(void) fetchRecentVideosFromServer
//{
//    //Preparing Parameter Dictionary to pass in API.
//    NSDictionary *paramSurveyAll = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @"10", @"limit",
//                                    nil];
//    
//    
//    NSURL *urlBase = [NSURL URLWithString:API_BASE_URL];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlBase];
//    
//    //Default setting.
//    httpClient.parameterEncoding = AFJSONParameterEncoding;
//    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
//    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    
//    
//    //Set Request.
//    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:API_RecentVideo_10 parameters:paramSurveyAll];
//    [request setTimeoutInterval:240];
//    
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//                                         {
//                                             if(JSON !=NULL && [JSON isKindOfClass:[NSArray class]])
//                                             {
//                                                 intRepeatCounter = 0;
//                                                 
//                                                 [aryMMetaDataOfRecent10 removeAllObjects];
//                                                 for(id objAry in JSON)
//                                                 {
//                                                     NSMutableDictionary *dictOfAData = (NSMutableDictionary *)objAry;
//                                                     [aryMMetaDataOfRecent10 addObject:[dictOfAData objectForKey:@"meta_value"]];
//                                                 }
//
//                                                 //Call methods to fetch thumnails from Parent Dictionary.
//                                                 [self parseThumnails];
//                                             }
//                                             else
//                                             {
//                                                 NSLog(@"Req JSON - %@",JSON);
//                                             }
//                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                             
//                                             intRepeatCounter = intRepeatCounter + 1;
//                                             
//                                             if(intRepeatCounter < 3)
//                                             {
//                                                 [self fetchRecentVideosFromServer];
//                                             }
//                                             else
//                                             {
//                                                 intRepeatCounter = 0;
//                                                 
//                                                 NSLog(@" Error - %@",error);
//                                             }
//                                         }];
//    
//    [operation start];
//    [operation waitUntilFinished];
//}
//

/**
 *  For fetching SingleVideo from server.
 */
-(void) fetchSingleVideoFromServer
{
    NSURL *urlBase = [NSURL URLWithString:API_BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlBase];
    
    //Default setting.
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    
    //Set Request.
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:API_Single_Video parameters:nil];
    [request setTimeoutInterval:240];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             if(JSON !=NULL)
                                             {
                                                 intRepeatCounter = 0;
                                                 
                                                 [aryMMetaDataOfRecent10 removeAllObjects];
                                                 
                                                 [aryMMetaDataOfRecent10 addObject:[JSON objectForKey:@"meta_value"]];
                                                 
                                                
                                                 //Call methods to fetch thumnails from Parent Dictionary.
                                                 [self parseTrendingVideos];
                                             }
                                             else
                                             {
                                                 NSLog(@"Req JSON - %@",JSON);
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             
                                             intRepeatCounter = intRepeatCounter + 1;
                                             
                                             if(intRepeatCounter < 3)
                                             {
                                                 [self fetchSingleVideoFromServer];
                                             }
                                             else
                                             {
                                                 intRepeatCounter = 0;
                                                 
                                                 NSLog(@" Error - %@",error);
                                             }
                                         }];
    
    [operation start];
    [operation waitUntilFinished];
}

/**
 *  For fetching SingleVideo from server.
 */
-(void) fetchSearchVideoByTag:(NSString*)tag limit:(int) limit
{
    //Preparing Parameter Dictionary to pass in API.
    NSDictionary *paramSurveyAll = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSString stringWithFormat:@"%d",limit], @"limit",
                                    nil];
    
    NSURL *urlBase = [NSURL URLWithString:API_BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlBase];
    
    //Default setting.
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    
    //Set Request.
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@%@",API_Video_By_Tag,tag ] parameters:paramSurveyAll];
    [request setTimeoutInterval:240];
    
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             if(JSON !=NULL && [JSON isKindOfClass:[NSArray class]])
                                             {
                                                 intRepeatCounter = 0;
                                                 
                                                 [aryMMetaDataOfRecent10 removeAllObjects];
                                                 [aryImageInfo removeAllObjects];
                                                 //Parse Data
                                                 for(id objAry in JSON)
                                                 {
                                                     NSMutableDictionary *dictOfAData = (NSMutableDictionary *)objAry;
                                                     [aryMMetaDataOfRecent10 addObject:[dictOfAData objectForKey:@"meta_value"]];
                                                     [aryImageInfo addObject:dictOfAData];
                                                 }
                                                 
                                                 //Call methods to fetch thumnails from Parent Dictionary.
                                                 [self parseThumnails];
                                             }
                                             else
                                             {
                                                 NSLog(@"Req JSON - %@",JSON);
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             
                                             intRepeatCounter = intRepeatCounter + 1;
                                             
                                             if(intRepeatCounter < 3)
                                             {
                                                 [self fetchSearchVideoByTag:tag limit:limit];
                                             }
                                             else
                                             {
                                                 intRepeatCounter = 0;
                                                 NSLog(@" Error - %@",error);
                                             }
                                         }];
    
    [operation start];
    [operation waitUntilFinished];
}

- (void) fetchImageFromServer{
    NSLog(@"fetch images");
    [aryMOfImages removeAllObjects];
    for (NSString* url in aryMThumnails) {
        UIImage *im = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_VIDEO_BASE_URL,url]]]];
        [aryMOfImages addObject:im];
    }
}

#pragma mark - Parsing Json Data of Response.
-(void) parseThumnails
{
    [aryMThumnails removeAllObjects];
    
//    NSMutableArray * arthumb;
    
    NSLog(@"%@",_currentAPI);
    DataManager* dt = [DataManager sharedManager];
    NSMutableArray * oldData = [dt getDataWithAPI:_currentAPI];
    for(NSString *strJsonData in aryMMetaDataOfRecent10)
    {
        NSError *error;
        NSData *jsonData = [strJsonData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictTemp1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        [aryMThumnails addObject:[dictTemp1 objectForKey:@"thumburl"]];
    }
    if(![strAPICallName isEqualToString:@"Photos"])
    {
        [self parseTrendingVideos];
    }
    
    if ([aryImageInfo isEqual:oldData]) {
        aryMOfImages = [dt getImagesWithAPI:_currentAPI];

    }else{
        [self fetchImageFromServer];
        [dt setImagesWithAPI:_currentAPI ImageArray:aryMOfImages];
    }
    
    [dt setDataWithAPI:_currentAPI Data:aryImageInfo];
    
    [self.pullToRefreshView finishLoading];
    [self.pullToRefreshView.contentView setLastUpdatedAt:[NSDate date] withPullToRefreshView:self.pullToRefreshView];
    [self removeLoading];
    [tblThumnails reloadData];
    

}

-(void) parseTrendingVideos
{
    [aryMTrendingVideos removeAllObjects];
    for(NSString *strJsonData in aryMMetaDataOfRecent10)
    {
        NSError *error;
        NSData *jsonData = [strJsonData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictTemp1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        [aryMTrendingVideos addObject:[dictTemp1 objectForKey:@"videourl"]];
    }
    
    NSLog(@"aryMTrendingVideos - %@",aryMTrendingVideos);
    
    if(![strAPICallName isEqualToString:@""])
    {
        //        [self showTablePopUp];
        //        [tblTrendingVideoList reloadData];
    }
    else if([strAPICallName isEqualToString:@""])
    {
        [self playVideoForURL:[aryMTrendingVideos objectAtIndex:0]];
    }
}


#pragma mark - TableView Datasource.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0; // Set height how much you wants here
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int numberOfRows = 0;
    
    numberOfRows = aryMThumnails.count / 2; //To make this of 3 columns, devide it by 3.
    if(aryMThumnails.count % 2 == 1)
    {
        numberOfRows = numberOfRows + 1;
    }
    NSLog(@"number row %d and number photo %d",numberOfRows,aryMThumnails.count);
    return numberOfRows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CataloguesIdentifier = @"CataloguesIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CataloguesIdentifier];
    
    UIImageView *imgView;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CataloguesIdentifier];
        
        //For column 3 copy paste code, if you need column 3 also. an dset tag as 3.Just manage its frame.
        
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    
    
    //For Column 1.
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 200)];
    imgView.tag = 1;
    imgView.image = [aryMOfImages objectAtIndex:indexPath.row*2];
    [cell.contentView addSubview:imgView];
    imgView = nil;
    
    UIButton *btnOnCell1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOnCell1.frame = CGRectMake(0, 0, 160, 200);
    btnOnCell1.tag = indexPath.row*2 + 1000;
    [btnOnCell1 addTarget:nil action:@selector(btnCellClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnOnCell1];
    
    
    NSLog(@"%d",aryMThumnails.count);
    NSLog(@"%d",(indexPath.row*2+1));
    
    //For Column 2.
//    if (indexPath.row*2+1!=15) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 160, 200)];
        imgView.tag = 2;
        imgView.image = [aryMOfImages objectAtIndex:indexPath.row*2+1];
        [cell.contentView addSubview:imgView];
        
        
        UIButton *btnOnCell2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOnCell2.frame = CGRectMake(160, 0, 160, 200);
        btnOnCell2.tag = (indexPath.row*2 + 1 + 1000);
        [btnOnCell2 addTarget:nil action:@selector(btnCellClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnOnCell2];
        imgView = nil;
        
//    }else{
//        UIView *view = [cell.contentView viewWithTag:2];
//        [view removeFromSuperview];
//        
//    }


    
    //if cell ends.
    //Resue cell.
//    else
//    {
//        //For column 1.
//        imgView = (UIImageView *)[cell.contentView viewWithTag:1];
//        if(aryMOfImages.count > indexPath.row)
//        {
//            imgView.image = [aryMOfImages objectAtIndex:indexPath.row];
//        }
//        else
//        {
//            imgView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_VIDEO_BASE_URL,[aryMThumnails objectAtIndex:indexPath.row]]]]];
//            [aryMOfImages addObject:imgView.image];
//        }
//        
//        
//        //For column 2.
//        imgView = (UIImageView *)[cell.contentView viewWithTag:2];
//        if(aryMThumnails.count > (indexPath.row + 1))
//        {
//            if((aryMOfImages.count) > (indexPath.row + 1))
//            {
//                imgView.image = [aryMOfImages objectAtIndex:(indexPath.row + 1)];
//                
//            }
//            else
//            {
//                imgView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_VIDEO_BASE_URL,[aryMThumnails objectAtIndex:(indexPath.row + 1)]]]]];
//                [aryMOfImages addObject:imgView.image];
//                
//            }
//        }
//    }
    
    //For button on column1.

    
    //For button on column2.

    
    //For button on column3. Copy pase button code if you need 3 columns just manage its frame.

    return cell;
}


#pragma mark - VideoButtonOnCell Methods.
// thg co ho
-(void)btnCellClick : (UIButton *) btnSender
{
    
    NSLog(@"btlog - %d",(btnSender.tag - 1000));
    if(![strAPICallName isEqualToString:@"Photos"])
    {
        [self playVideoForURL:[aryMTrendingVideos objectAtIndex:(btnSender.tag - 1000)]];
        
    }else{
        NSDictionary *dic = [aryImageInfo objectAtIndex:btnSender.tag-1000];
        UIImage *image = [aryMOfImages objectAtIndex:btnSender.tag-1000];
        ImageViewController *imgVC = [[ImageViewController alloc] initWithImage:image andData:dic];
        [self.navigationController pushViewController:imgVC animated:YES];
        
    }
}


#pragma mark - Video Playing Methods.
-(void) playVideoForURL: (NSString *)strURLForVideo
{

    _videoPlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"%@%@",API_VIDEO_BASE_URL,strURLForVideo]]];
    _videoPlayerView.view.frame = CGRectMake(0, 420, 320, 148);
    [self.navigationController presentMoviePlayerViewControllerAnimated:_videoPlayerView];
    //[self.view addSubview:_videoPlayerView.view];

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
    
//    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
//        [moviePlayer.view removeFromSuperview];
//    }
}
- (IBAction)searchBtnAction:(id)sender {
    UIBarButtonItem* negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-5];
    
    
    UIButton *closebtn = [[UIButton alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width/7, 44.0f)];
//    [closebtn setImage:[UIImage imageNamed:@"closebtn.png"] forState:UIControlStateNormal];
    [closebtn setTitle:@"Close" forState:UIControlStateNormal];
    closebtn.titleLabel.font = [UIFont fontWithName:@"Verdana" size:10];
    closebtn.titleLabel.textColor = [UIColor blackColor];
    [closebtn addTarget:self action:@selector(closeSearch) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeSearch)];
    
    
    CGRect searchFrame = CGRectMake(0, 0, self.view.frame.size.width*5/6, 44);
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    UIBarButtonItem *sb = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    [searchBar becomeFirstResponder];
    searchBar.delegate = self;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,closeBarBtn,sb,nil];
    
    
}

- (void) closeSearch
{
    NSLog(@"123");
    UIBarButtonItem *sb = [[UIBarButtonItem alloc] initWithCustomView:self.btnSearch];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:sb,nil];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search %@",searchBar.text);
    [self fetchSearchVideoByTag:searchBar.text limit:10];
}

#pragma mark MSPullToRefreshDelegate Methods

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self.pullToRefreshView startLoading];
    [self fetchThumbnailsFromServer:_currentAPI Limit:16];
    
}

- (void)showLoading
{
    if (!self.loadingView)
    {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 300, 21)];
        label.text = @"Loading...";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        
        [self.loadingView addSubview:label];
        self.loadingView.backgroundColor = [self colorWithHexString:@"#226CA4"];
        
        [self.view addSubview:self.loadingView];
        [self.view bringSubviewToFront:self.loadingView];
    }
    
    [self.pullToRefreshView finishLoading];
    
    [UIView animateWithDuration:0.3f animations:^() {
        self.loadingView.frame = CGRectMake(0, 64, 320, 44);
    }];
}

- (void)removeLoading
{
    [UIView animateWithDuration:0.3f animations:^() {
        self.loadingView.frame = CGRectMake(0, -44, 320, 44);
    }];
}

- (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [self colorWithHex:x];
}

- (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

@end
