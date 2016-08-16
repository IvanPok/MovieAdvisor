//
//  ViewController.m
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/6/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//



#import "ViewController.h"
#import <objc/message.h>

NSString* const kApi_key = @"77d6b9687a88c7af7d344deda5b2b747";
NSString* const kBaseUrlString = @"http://api.themoviedb.org/3";
NSString* const kConfiguration = @"configuration";
NSString* const kMovieGenreList = @"genre/movie/list";
NSString* const kTVGenreList = @"genre/tv/list";
NSString* const kDiscoverMovie = @"discover/movie";
NSString* const kDiscoverTV = @"discover/tv";
NSString* const kMovieCasts = @"movie/{id}/casts";
NSString* const kMovieTrailer = @"movie/{id}/trailers";
NSString* const kTVCasts = @"tv/{id}/credits";
NSString* const kTVTrailer = @"tv/{id}/videos";
NSInteger const kCountPerPage = 20;

@interface ViewController ()
{
    int basicinfo_loadingtime;
    int maininfo_loadingtime;
    NSString *imageBaseUrlString;
    NSString *imageBaseUrlStringW92;
    NSMutableArray *movieGenres, *tvGenres;
    NSMutableArray *availablePages, *availableIndexes;
    NSMutableArray *url_backdrops;
    NSMutableDictionary *discoverMovieParam;
    int randomPageNum, randomMovieNum;
}
@end

@implementation ViewController
- (void)viewDidLoad {
#if __LP64__
    // The app has been compiled for 64-bit intel and runs as 64-bit intel
    NSLog(@"64");
#endif
    
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeeded) name:@"succeeded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failed) name:@"failed" object:nil];
    
    [_backScrollView setHidden:YES];
    _indicatorView.hidesWhenStopped = YES;
    
    _bannerView.adUnitID = @"ca-app-pub-9356011367537885/7721820858";
    _bannerView.rootViewController = self;
    [_bannerView loadRequest:[GADRequest request]];
    [self GetAllBasicInfos];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)onPlayButton:(id)sender {
    [_trailerPlayer playVideo];
}


-(void)setProperLayouts{
    if (_filterInfo.recommendtvshows==YES) {
        [_ForeScrollViewHeightConstraint setConstant:_foreScrollView.frame.size.width*9.0f/16.0f];
    }else{
        [_ForeScrollViewHeightConstraint setConstant:_foreScrollView.frame.size.width*3.0f/4.0f];
    }
    
    [_txt_Casting setScrollEnabled:YES];
    [_txt_Description setScrollEnabled:YES];
    
    [_CastingTextHeightConstraint setConstant:MAX([self textViewHeightForAttributedText:_txt_Casting],60)];
    [_DescriptionTextHeightConstraint setConstant:[self textViewHeightForAttributedText:_txt_Description]];
    
    [_txt_Casting setScrollEnabled:NO];
    [_txt_Description setScrollEnabled:NO];
    
    [self.view updateConstraintsIfNeeded];
    
    int estimated_height=_foreScrollView.frame.origin.y+_foreScrollView.frame.size.width*(_filterInfo.recommendtvshows?9.0f/16.0f:3.0f/4.0f)+
    MAX([self textViewHeightForAttributedText:_txt_Casting],60)+
    _view_Director.frame.size.height+
    _lbl_AddToWatchLater.frame.size.height+
    _btn_AddToWatchLaterButton.frame.size.height+
    [self textViewHeightForAttributedText:_txt_Description];
    
    [_backScrollView setContentSize:CGSizeMake(self.view.frame.size.width, estimated_height)];
    
    [self.view bringSubviewToFront:_indicatorView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void) viewDidLayoutSubviews{

}

-(void)viewWillAppear:(BOOL)animated{
    NSNumber *number=[[NSUserDefaults standardUserDefaults] objectForKey:@"number"];
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"WatchLater"];
    NSString *movie_id;
    _watchLaterList=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    movie_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedWatchLater"];
    WatchLaterItem *watchLaterItem=[_watchLaterList.watchlater_list objectForKey:movie_id];
    
    if (data==nil || watchLaterItem==nil) {
        if (number.boolValue==YES) {
            [self GetAllBasicInfos];
        }
    }else{
        _movie_id=movie_id;
        dispatch_async(dispatch_get_main_queue(), ^{
        [_indicatorView startAnimating];
        maininfo_loadingtime=0;
        [self performSelectorInBackground:@selector(LoadSelectedItem:) withObject:watchLaterItem];
        });
    }
}

-(void)GetAllBasicInfos{
    
    [_indicatorView startAnimating];
    basicinfo_loadingtime=0;
    [self GetImageUrl];
    [self GetGenres];
    [self GetFilterInfo];
    [self GetWatchLaterList];
}

//Description : Go to the criteria_viewcontroller
//Params :
//Return :
- (IBAction)onCriteriaButton:(id)sender {
    NSNumber *number= [NSNumber numberWithBool:NO];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"number"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_filterInfo];
    @synchronized(data)
    {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"filterInfo"];
    }
    [Global ChangeScene:self storyboard_id:@"criteria_viewcontroller" moveLeft:YES];
}

//Description : Go to the watchlater_viewcontroller
//Params :
//Return :
- (IBAction)onWatchLaterButton:(id)sender {
    [Global ChangeScene:self storyboard_id:@"watchlater_viewcontroller" moveLeft:NO];
}

- (CGFloat)textViewHeightForAttributedText:
    (UITextView *)textView
{
    [textView setAttributedText:textView.attributedText];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    return size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Description : Send Request to MovieDB
//Params : endpoint-suburl, parameters-dictionary type params, callback- callback function.
//Return :
- (void)sendRequestWithEndPoint:(NSString*)endpoint parameter:(NSDictionary*)parameters callback:(ResponseCallback)block
{
    NSMutableDictionary *keyParameters = parameters ? [parameters mutableCopy] : [@{} mutableCopy];
    
    if ([endpoint rangeOfString:@"{id}"].location != NSNotFound) {
        NSAssert(keyParameters[@"id"] != nil, @"Please, add the id");
        if (![keyParameters[@"id"] isKindOfClass:[NSString class]])
            keyParameters[@"id"] = [keyParameters[@"id"] stringValue];
        endpoint = [endpoint stringByReplacingOccurrencesOfString:@"{id}" withString:keyParameters[@"id"]];
    }
    
    __block NSString *param = @"";
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        if ([key isEqualToString:@"id"])
            return;
        param = [param stringByAppendingFormat:@"&%@=%@", key, obj];
        
    }];
    
    endpoint = [NSString stringWithFormat:@"%@/%@?api_key=%@%@", kBaseUrlString, endpoint, kApi_key, param];
    NSString* encodedString = [endpoint stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error) {
                                          NSLog(@"ERROR = %@", error);
                                          // Handle error...
                                          return;
                                      }
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                      }
                                      
                                      NSDictionary *tmp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                      block(tmp, error);
                                  }];
    [task resume];
}

//Functions to Get the basic Informations
-(void)GetImageUrl{
    basicinfo_loadingtime++;
    [self sendRequestWithEndPoint:kConfiguration parameter:nil callback:^(NSDictionary* response, NSError *error){
        NSLog(@"%@",response);
        imageBaseUrlString = [response[@"images"][@"base_url"] stringByAppendingString:@"w300"];
        imageBaseUrlStringW92 = [response[@"images"][@"base_url"] stringByAppendingString:@"w92"];
        [self LoadMainInfoAfterChecking];
    }];
}

-(void)GetGenres{

    basicinfo_loadingtime+=2;
    NSString *endpoint;
    if (_filterInfo.recommendtvshows) {
        endpoint=kTVGenreList;
    }else{
        endpoint=kMovieGenreList;
    }
    [self sendRequestWithEndPoint:kMovieGenreList parameter:nil callback:^(NSDictionary* response, NSError *error){
        movieGenres = [response[@"genres"] mutableCopy];
        for (int i = 0; i < [movieGenres count]; i++) {
            if ([movieGenres[i][@"name"] isEqualToString:@"Erotic"]) {
                [movieGenres removeObjectAtIndex:i];
                break;
            }
        }
        [self LoadMainInfoAfterChecking];
    }];
    [self sendRequestWithEndPoint:kTVGenreList parameter:nil callback:^(NSDictionary* response, NSError *error){
        tvGenres = [response[@"genres"] mutableCopy];
        //NSLog(@"%@",tvGenres);
        for (int i = 0; i < [tvGenres count]; i++) {
            if ([tvGenres[i][@"name"] isEqualToString:@"Erotic"]) {
                [tvGenres removeObjectAtIndex:i];
                break;
            }
        }
        
        [self LoadMainInfoAfterChecking];
    }];
}

-(void)GetFilterInfo{
    basicinfo_loadingtime++;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterInfo"];
    if (data == nil) {
        _filterInfo = [FilterInfo new];
        _filterInfo.movieGenreSelected = [NSMutableArray array];
        _filterInfo.tvGenreSelected = [NSMutableArray array];
        _filterInfo.minYear = 1980;
        _filterInfo.highrate_only = NO;
        _filterInfo.recommendtvshows=NO;
    }
    else
        _filterInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self LoadMainInfoAfterChecking];
}

-(void)GetWatchLaterList{
    basicinfo_loadingtime++;
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"WatchLater"];
    if (data==nil) {
        _watchLaterList=[WatchLaterList new];
        _watchLaterList.watchlater_list=[NSMutableDictionary dictionary];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_watchLaterList];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"WatchLater"];
    }else{
        _watchLaterList=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (_watchLaterList==nil) {
            _watchLaterList=[WatchLaterList new];
            _watchLaterList.watchlater_list=[NSMutableDictionary dictionary];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_watchLaterList];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"WatchLater"];
        }
    }
    [self LoadMainInfoAfterChecking];
}

-(void)LoadMainInfoAfterChecking{
    if (--basicinfo_loadingtime==0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _filterInfo.movieGenres=[movieGenres copy];
            _filterInfo.tvGenres=[tvGenres copy];
            [_indicatorView stopAnimating];
            [self LoadMainInfo];
        });
        
    }
}

-(void)LoadMainInfo{
    _lbl_NoVideo.text=@"";
    [_btn_Play setHidden:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_trailerPlayer.webView removeFromSuperview];
        
        [_indicatorView startAnimating];
    });
    maininfo_loadingtime=0;
    [self loadMovieData];
    [self initialize];
}

-(void)loadMovieData{
    maininfo_loadingtime++;
    //if (availablePages == nil) {
        NSDictionary *param = [NSDictionary dictionary];
        NSString *genreStr = @"";
        int count=(int)(_filterInfo.recommendtvshows?_filterInfo.tvGenres.count:_filterInfo.movieGenres.count);

        for (int i = 0; i < count; i++) {
            BOOL isSelected = [[_filterInfo.recommendtvshows?_filterInfo.tvGenreSelected:_filterInfo.movieGenreSelected filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",[_filterInfo.recommendtvshows?_filterInfo.tvGenres[i]:_filterInfo.movieGenres[i] objectForKey:@"name"]]] count]>0?YES:NO;
            if (isSelected)
            {
                genreStr = [genreStr stringByAppendingFormat:@"%@|", [_filterInfo.recommendtvshows?_filterInfo.tvGenres[i]:_filterInfo.movieGenres[i] objectForKey:@"id"]];
            }
        }
        NSLog(@"%@",genreStr);
        if (![genreStr isEqualToString:@""]) {
            genreStr = [genreStr substringToIndex:genreStr.length-1];
        }
        
        NSString *minReleaseDate = [NSString stringWithFormat:@"%4d-01-01", (int)_filterInfo.minYear];
        NSString *minRating = _filterInfo.highrate_only?@"7.0":@"0.0";
        param = [NSDictionary dictionaryWithObjectsAndKeys:genreStr, @"with_genres", minReleaseDate, @"release_date.gte", minRating, @"vote_average.gte",minReleaseDate,@"first_air_date.gte", nil];
        discoverMovieParam = [param mutableCopy];
        
        [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?kDiscoverTV:kDiscoverMovie parameter:param callback:^(NSDictionary* response, NSError *error){
            //NSLog(@"%@",response);
            if ([response[@"total_results"] intValue] < 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //movieTitleLabel.text = @"No Result!";
                    //[indicatorView stopAnimating];
                });
                
                return;
            }else{
                int totalPages = MIN([response[@"total_pages"] intValue], 998);
            
                availablePages = [NSMutableArray array];
                for (int i = 0; i < totalPages; i++) {
                    NSNumber *number = [NSNumber numberWithInt:i];
                    [availablePages addObject:number];
                }
            
                availableIndexes = [NSMutableArray array];
                for (int i = 0; i < kCountPerPage; i++) {
                    NSNumber *number = [NSNumber numberWithInt:i];
                    [availableIndexes addObject:number];
                }
                randomPageNum = arc4random() % availablePages.count;
                randomMovieNum = arc4random() % kCountPerPage;
            
                [self checkAvailability];
                [self LoadDoneAfterChecking];
                
            }
        }];
   /* }
    else
    {
        randomPageNum = [availablePages[arc4random() % availablePages.count] intValue];
        availableIndexes = [NSMutableArray array];
        for (int i = 0; i < kCountPerPage; i++) {
            NSNumber *number = [NSNumber numberWithInt:i];
            [availableIndexes addObject:number];
        }
        randomMovieNum = arc4random() % kCountPerPage;
        [self checkAvailability];
        [self LoadDoneAfterChecking];
    }
    */
    
}

- (void) checkAvailability
{
    maininfo_loadingtime++;
    NSString *page = [NSString stringWithFormat:@"%d", randomPageNum+1];
    [discoverMovieParam setObject:page forKey:@"page"];
    
    [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?kDiscoverTV:kDiscoverMovie parameter:discoverMovieParam callback:^(NSDictionary *response, NSError *error) {
        int index = randomMovieNum;
        
        if ([response[@"results"] count] < index+1 || response[@"results"][index][@"title"] == [NSNull null] || response[@"results"][index][@"release_date"] == [NSNull null] || response[@"results"][index][@"poster_path"] == [NSNull null])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"failed" object:nil];
            return;
        }
        
       NSDictionary *param1 = [NSDictionary dictionaryWithObjectsAndKeys:response[@"results"][index][@"id"], @"id", nil];
        
        [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?@"tv/{id}":@"movie/{id}" parameter:param1 callback:^(NSDictionary *response, NSError *error) {
            
            if (response[@"overview"] == [NSNull null])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"failed" object:nil];
                return ;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"succeeded" object:nil];
            //NSLog(@"%@",param1);
            [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?kTVTrailer:kMovieTrailer parameter:param1 callback:^(NSDictionary *response, NSError *error) {
                /*NSString *arg=_filterInfo.recommendtvshows==YES?@"results":@"youtube";
                if (response[arg] == [NSNull null] || [response[arg] count] == 0)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"failed" object:nil];
                    return ;
                }*/
                
                [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?kTVCasts:kMovieCasts parameter:param1 callback:^(NSDictionary *response, NSError *error) {
                    /*if (response[@"cast"] == [NSNull null] || [response[@"cast"] count] == 0)
                    {
                        NSLog(@"cast error");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"failed" object:nil];
                        return ;
                    }
                    
                    if (response[@"crew"] == [NSNull null] || [response[@"crew"] count] == 0)
                    {
                        NSLog(@"crew error");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"failed" object:nil];
                        return;
                    }*/
                    
                }];
                
            }];
        }];
        
    }];
}

- (void)succeeded{
    
    [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?kDiscoverTV:kDiscoverMovie parameter:discoverMovieParam callback:^(NSDictionary *response, NSError *error) {
        maininfo_loadingtime++;
        __block int index = randomMovieNum;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _lbl_MovieTitle.text = response[@"results"][index][_filterInfo.recommendtvshows?@"original_name":@"title"];
            _lbl_MovieTitle.adjustsFontSizeToFitWidth = YES;
            self.navigationItem.titleView = _lbl_MovieTitle;
            if (_filterInfo.recommendtvshows){
                _lbl_Year.text = [response[@"results"][index][@"first_air_date"] substringToIndex:4];
            }else{
                _lbl_Year.text = [response[@"results"][index][@"release_date"] substringToIndex:4];
            }
           
            NSString *imageUrl = [imageBaseUrlStringW92 stringByAppendingPathComponent:response[@"results"][index][@"poster_path"] ];
            _img_url=imageUrl;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            _img_post.image = img;
            
            _movie_id=[NSString stringWithFormat:@"%@:%@:%@",_filterInfo.recommendtvshows?@"tv":@"movie",[discoverMovieParam objectForKey:@"page"],response[@"results"][index][@"id"]];
        });
          NSDictionary *param1 = [NSDictionary dictionaryWithObjectsAndKeys:response[@"results"][index][@"id"], @"id", nil];
        if (_filterInfo.recommendtvshows==YES)
        {
            
            [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?@"tv/{id}/images":@"movie/{id}/images" parameter:param1 callback:^(NSDictionary *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_foreScrollView setHidden:NO];
                NSArray *viewsToRemove = [_foreScrollView subviews];

                for (UIView *v in viewsToRemove) {
                    [v removeFromSuperview];
                }
                
                NSUInteger backdrop_count=5;
                if ([response[@"backdrops"] count]<5) {
                    backdrop_count=[response[@"backdrops"] count];
                }
                
                url_backdrops=[NSMutableArray array];
                for (int i=0; i<backdrop_count; i++) {
                    [url_backdrops addObject:response[@"backdrops"][i][@"file_path"]];
                }
                
                for (int i = 0; i < backdrop_count; i++) {
                    NSString *imageUrl = [imageBaseUrlString stringByAppendingPathComponent:response[@"backdrops"][i][@"file_path"] ];
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    
                    UIImageView *image_view=[[UIImageView alloc] initWithImage:img];
                    image_view.frame = CGRectMake(_foreScrollView.frame.size.width*(i+0.05f), _foreScrollView.frame.size.width*9/16.0f*0.05f, _foreScrollView.frame.size.width*0.9f, _foreScrollView.frame.size.width*9/16.0f*0.9f);
                    [_foreScrollView addSubview:image_view];
                    
                }
                if (backdrop_count==0) {
                    [_foreScrollView setContentSize:CGSizeMake(_foreScrollView.frame.size.width, _foreScrollView.frame.size.height)];
                    _lbl_NoImage.text = @"Sorry, the backdrop image is not available";
                    [_lbl_NoImage setHidden:NO];
                }else{
                    [_foreScrollView setContentSize:CGSizeMake(backdrop_count*_foreScrollView.frame.size.width, _foreScrollView.frame.size.width*9.0f/16.0f)];
                    [_lbl_NoImage setHidden:YES];
                }
                
            });
            }];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_foreScrollView setHidden:YES];
                [_lbl_NoImage setHidden:YES];
            });
        }
        
          //  NSDictionary *param1 = [NSDictionary dictionaryWithObjectsAndKeys:@1399, @"id", nil];
        
        [self sendRequestWithEndPoint:_filterInfo.recommendtvshows==YES?@"tv/{id}":@"movie/{id}" parameter:param1 callback:^(NSDictionary *response, NSError *error) {
            maininfo_loadingtime+=2;
            //            NSLog(@"*********** %@", response);
            NSString *overview = response[@"overview"];
            if ([overview isEqualToString:@""]) {
                overview = @"unknown";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *genres = @"";
                for (int i = 0; i < [response[@"genres"] count]; i++) {
                    if (i>2) {
                        break;
                    }
                    genres = [genres stringByAppendingFormat:@"%@\n", response[@"genres"][i][@"name"]];
                }
                if (![genres isEqualToString:@""]) {
                    genres = [genres substringToIndex:genres.length - 1];
                } else {
                    genres = @"unknown";
                }
                _lbl_Genres.text = genres;
                _lbl_Genres.adjustsFontSizeToFitWidth = YES;
                
                NSNumber *number = response[@"runtime"];
                if (number != nil) {
                    _lbl_Duration.text = [NSString stringWithFormat:@"%@ minutes", [number stringValue]];
                }else{
                    _lbl_Duration.text=@"unknown";
                }
                number = response[@"vote_average"];
                _lbl_Rating.text = [NSString stringWithFormat:@"%.1f", number.floatValue];
                
                for (int i = 0; i < 10; i++) {
                    if (i + 1 <= round(number.floatValue)) {
                        [_RateStar[i] setImage:[UIImage imageNamed:@"rating-f.png"]];
                    }else
                        [_RateStar[i] setImage:[UIImage imageNamed:@"rating-e.png"]];
                }
            });
            
            [self sendRequestWithEndPoint:_filterInfo.recommendtvshows?kTVTrailer:kMovieTrailer parameter:param1 callback:^(NSDictionary *response, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *avg=_filterInfo.recommendtvshows?@"results":@"youtube";
                    NSArray *array = response[avg];
                    if (array == nil || array.count == 0 || _filterInfo.recommendtvshows) {
                        _lbl_NoVideo.text = @"Sorry, the trailer is not available";
                        [_btn_Play setHidden:YES];
                        _video_id=nil;
                    }else
                    {
                        avg=_filterInfo.recommendtvshows?@"id":@"source";
                        [_trailerPlayer loadWithVideoId:array[0][avg]];
                        _video_id=array[0][avg];
                        [_btn_Play setHidden:NO];
                    }
                });
                [self LoadDoneAfterChecking];
            }];
            
            [self sendRequestWithEndPoint:_filterInfo.recommendtvshows?kTVCasts:kMovieCasts parameter:param1 callback:^(NSDictionary *response, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *cast = @"", *director = @"";
                    NSInteger n = MIN([response[@"cast"] count], 7);
                    for (int i = 0; i < n; i++) {
                        cast = [cast stringByAppendingFormat:@"%@\n", response[@"cast"][i][@"name"]];
                    }
                    if (![cast isEqualToString:@""]) {
                        cast = [cast substringToIndex:cast.length-2];
                    } else {
                        cast = @"unknown";
                    }
                    
                    NSArray *array = response[@"crew"];
                    for (int i = 0; i < [array count]; i++) {
                        if ([array[i][@"job"] isEqualToString:@"Director"]) {
                            director = [director stringByAppendingFormat:@"%@, ", array[i][@"name"]];
                        }
                    }
                    if (![director isEqualToString:@""]) {
                        director = [director substringToIndex:director.length-2];
                    } else {
                        director = @"unknown";
                    }
                    
                    _txt_Casting.text = cast;
                    _txt_Director.text = director;
                    _txt_Description.text = overview;
                    
                    [self LoadDoneAfterChecking];
                });
            }];
            [self LoadDoneAfterChecking];
        }];
        [self LoadDoneAfterChecking];
    }];
}

-(void)LoadSelectedItem:(WatchLaterItem*)watchLaterItem{
    
    maininfo_loadingtime++;
    [_trailerPlayer.webView removeFromSuperview];
    _lbl_MovieTitle.text=watchLaterItem.title;
    _lbl_Year.text=watchLaterItem.year;
    _lbl_Rating.text=watchLaterItem.rate;
    _lbl_Duration.text=watchLaterItem.time;
    _lbl_Genres.text=watchLaterItem.genres;
    dispatch_sync(dispatch_get_main_queue(), ^{
        _lbl_NoVideo.text=@"";
        [_btn_Play setHidden:YES];
        _txt_Casting.text=watchLaterItem.casting;
        _txt_Description.text=watchLaterItem.overview;
        _txt_Director.text=watchLaterItem.director;
        if (watchLaterItem.is_tvshows.intValue>0) {
            [_foreScrollView setHidden:NO];
            [_lbl_NoImage setHidden:NO];
            NSArray *viewsToRemove = [_foreScrollView subviews];
            
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
            
            NSUInteger backdrop_count=[watchLaterItem.url_backdrop count];
            for (int i = 0; i < backdrop_count; i++) {
                NSString *imageUrl = [imageBaseUrlString stringByAppendingPathComponent:watchLaterItem.url_backdrop[i]];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                UIImage *img = [[UIImage alloc] initWithData:data];
                
                UIImageView *image_view=[[UIImageView alloc] initWithImage:img];
                image_view.frame = CGRectMake(_foreScrollView.frame.size.width*(i+0.05f), _foreScrollView.frame.size.width*9/16.0f*0.05f, _foreScrollView.frame.size.width*0.9f, _foreScrollView.frame.size.width*9/16.0f*0.9f);
                [_foreScrollView addSubview:image_view];
                
            }
            if (backdrop_count==0) {
                [_foreScrollView setContentSize:CGSizeMake(_foreScrollView.frame.size.width, _foreScrollView.frame.size.height)];
                _lbl_NoImage.text = @"Sorry, the backdrop image is not available";
                [_lbl_NoImage setHidden:NO];
            }else{
                [_foreScrollView setContentSize:CGSizeMake(backdrop_count*_foreScrollView.frame.size.width, _foreScrollView.frame.size.width*9.0f/16.0f)];
                [_lbl_NoImage setHidden:YES];
            }

        }else{
            [_foreScrollView setHidden:YES];
            [_lbl_NoImage setHidden:YES];
            _video_id=watchLaterItem.video_id;
            if (_video_id== nil ) {
                _lbl_NoVideo.text = @"Sorry, the trailer is not available";
                [_btn_Play setHidden:YES];
            }else
            {
                [_trailerPlayer loadWithVideoId:_video_id];
                [_btn_Play setHidden:NO];
            }
        }
        [self CheckAddWatchLaterButton];
    });
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:watchLaterItem.rate];
    float number=myNumber.floatValue;
    for (int i = 0; i < 10; i++) {
        if (i + 1 <= round(number)) {
            [_RateStar[i] setImage:[UIImage imageNamed:@"rating-f.png"]];
        }else
            [_RateStar[i] setImage:[UIImage imageNamed:@"rating-e.png"]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedWatchLater"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:watchLaterItem.img_url]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    _img_post.image=img;
    [self LoadDoneAfterChecking];
}

- (void)failed{
    if ((int)availableIndexes.count > 1) {
        [availableIndexes removeObject:[NSNumber numberWithInt:randomMovieNum]];
        randomMovieNum = [availableIndexes[arc4random() % availableIndexes.count] intValue];
    }
    else if ((int)availablePages.count > 1) {
        [availablePages removeObject:[NSNumber numberWithInt:randomPageNum]];
        randomPageNum = [availablePages[arc4random() % availablePages.count] intValue];
        
        for (int i = 0; i < kCountPerPage; i++) {
            NSNumber *number = [NSNumber numberWithInt:i];
            [availableIndexes addObject:number];
        }
        randomMovieNum = [availableIndexes[arc4random() % availableIndexes.count] intValue];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //movieTitleLabel.text = @"No Result!";
            //[indicatorView stopAnimating];
        });
        return;
    }
    maininfo_loadingtime--;
    [self checkAvailability];
}

-(void)initialize{
    maininfo_loadingtime++;
    [self LoadDoneAfterChecking];
    
}

-(void) LoadDoneAfterChecking{
    if (--maininfo_loadingtime==0) [self LoadDone];
}
-(void) LoadDone{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setProperLayouts];
        [_backScrollView setHidden:NO];
        [_indicatorView stopAnimating];
        [self CheckAddWatchLaterButton];
    });
}

-(void) CheckAddWatchLaterButton{
    if ([_watchLaterList.watchlater_list objectForKey:_movie_id]==nil) {
        [_btn_AddToWatchLaterButton setEnabled:YES];
    }else
        [_btn_AddToWatchLaterButton setEnabled:NO];
}

- (IBAction)onRefreshButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedWatchLater"];
    [self LoadMainInfo];
}
- (IBAction)onAddToWatchLater:(id)sender {

    if ([_watchLaterList.watchlater_list objectForKey:_movie_id]==nil) {
        WatchLaterItem *watchLaterItem=[[WatchLaterItem alloc] init];
        watchLaterItem.title=_lbl_MovieTitle.text;
        watchLaterItem.year=_lbl_Year.text;
        watchLaterItem.genres=_lbl_Genres.text;
        watchLaterItem.time=_lbl_Duration.text;
        watchLaterItem.rate=_lbl_Rating.text;
        watchLaterItem.img_url=_img_url;
        watchLaterItem.director=_txt_Director.text;
        watchLaterItem.overview=_txt_Description.text;
        watchLaterItem.casting=_txt_Casting.text;
        watchLaterItem.video_id=_video_id;
        if (_filterInfo.recommendtvshows) {
            watchLaterItem.url_backdrop=url_backdrops;
        }
        watchLaterItem.is_tvshows=[NSNumber numberWithBool:_filterInfo.recommendtvshows];
        [_watchLaterList.watchlater_list setObject:watchLaterItem forKey:_movie_id];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_watchLaterList];
    @synchronized(data)
    {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"WatchLater"];
    }
    [self CheckAddWatchLaterButton];
}

@end
