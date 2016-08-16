//
//  WatchLaterItem.h
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/10/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchLaterItem : NSObject
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *genres;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *casting;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSNumber *is_tvshows;
@property (nonatomic, strong) NSArray *url_backdrop;
@end
