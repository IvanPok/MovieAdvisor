//
//  WatchLaterItem.m
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/10/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import "WatchLaterItem.h"

@implementation WatchLaterItem
@synthesize img_url,title,year,genres,rate,time,casting,director,overview,video_id,is_tvshows,url_backdrop;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        img_url = [aDecoder decodeObjectForKey:@"img_url"];
        title = [aDecoder decodeObjectForKey:@"title"];
        year = [aDecoder decodeObjectForKey:@"year"];
        genres = [aDecoder decodeObjectForKey:@"genres"];
        rate = [aDecoder decodeObjectForKey:@"rate"];
        time = [aDecoder decodeObjectForKey:@"time"];
        casting = [aDecoder decodeObjectForKey:@"casting"];
        director = [aDecoder decodeObjectForKey:@"director"];
        overview = [aDecoder decodeObjectForKey:@"overview"];
         video_id = [aDecoder decodeObjectForKey:@"video_id"];
        is_tvshows = [aDecoder decodeObjectForKey:@"is_tvshows"];
        url_backdrop = [aDecoder decodeObjectForKey:@"url_backdrop"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:img_url forKey:@"img_url"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:year forKey:@"year"];
    [aCoder encodeObject:genres forKey:@"genres"];
    [aCoder encodeObject:rate forKey:@"rate"];
    [aCoder encodeObject:time forKey:@"time"];
    [aCoder encodeObject:casting forKey:@"casting"];
    [aCoder encodeObject:director forKey:@"director"];
    [aCoder encodeObject:overview forKey:@"overview"];
    [aCoder encodeObject:video_id forKey:@"video_id"];
    [aCoder encodeObject:is_tvshows forKey:@"is_tvshows"];
    [aCoder encodeObject:url_backdrop forKey:@"url_backdrop"];
}
@end
