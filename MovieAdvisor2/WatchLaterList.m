//
//  WatchLaterList.m
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/10/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import "WatchLaterList.h"

@implementation WatchLaterList
@synthesize watchlater_list;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        watchlater_list = [aDecoder decodeObjectForKey:@"watchlater_list"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:watchlater_list forKey:@"watchlater_list"];
}
@end
