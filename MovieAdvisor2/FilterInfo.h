//
//  FilterInfo.h
//  MovieAdvisor
//
//  Created by Jirí Janoušek on 07/10/14.
//  Copyright (c) 2014 Jirí Janoušek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterInfo : NSObject<NSCoding>

@property (nonatomic, strong) NSMutableArray *movieGenreSelected;
@property (nonatomic, strong) NSMutableArray *tvGenreSelected;
@property (nonatomic) NSInteger minYear;
@property (nonatomic) BOOL highrate_only;
@property (nonatomic) BOOL recommendtvshows;
@property (nonatomic) NSMutableArray *movieGenres, *tvGenres;

@end
