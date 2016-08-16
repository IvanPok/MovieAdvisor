//
//  FilterInfo.m
//  MovieAdvisor
//
//  Created by Jirí Janoušek on 07/10/14.
//  Copyright (c) 2014 Jirí Janoušek. All rights reserved.
//

#import "FilterInfo.h"

@implementation FilterInfo
@synthesize movieGenreSelected, tvGenreSelected, minYear, highrate_only, recommendtvshows, movieGenres, tvGenres;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        movieGenreSelected = [aDecoder decodeObjectForKey:@"movieGenreSelected"];
        tvGenreSelected = [aDecoder decodeObjectForKey:@"tvGenreSelected"];
        minYear = [aDecoder decodeIntegerForKey:@"minYear"];
        highrate_only = [aDecoder decodeFloatForKey:@"highrate_only"];
        recommendtvshows = [aDecoder decodeFloatForKey:@"recommendtvshows"];
        movieGenres = [aDecoder decodeObjectForKey:@"movieGenres"];
        tvGenres = [aDecoder decodeObjectForKey:@"tvGenres"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:movieGenreSelected forKey:@"movieGenreSelected"];
    [aCoder encodeObject:tvGenreSelected forKey:@"tvGenreSelected"];
    [aCoder encodeInteger:minYear forKey:@"minYear"];
    [aCoder encodeFloat:highrate_only forKey:@"highrate_only"];
    [aCoder encodeFloat:recommendtvshows forKey:@"recommendtvshows"];
    [aCoder encodeObject:movieGenres forKey:@"movieGenres"];
    [aCoder encodeObject:tvGenres forKey:@"tvGenres"];
}
@end
