//
//  CriteriaViewController.m
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/7/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import "CriteriaViewController.h"

@implementation CriteriaViewController

-(void)viewDidLoad{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterInfo"];
    _filterInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //_filterInfo
    _highrate_only.on=_filterInfo.highrate_only;
    _recommendtvshows.on=_filterInfo.recommendtvshows;
    _yearLabel.text=[NSString stringWithFormat:@"%ld",(long)_filterInfo.minYear];
    _yearSlider.value=_filterInfo.minYear;
    row_height=20.0f;
    [_yearSlider setMinimumTrackTintColor:[UIColor grayColor]];
    [_yearSlider setMaximumTrackTintColor:[UIColor colorWithRed:0 green:156/255.0f blue:222/255.0f alpha:1.0f]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _filterInfo.recommendtvshows?[_filterInfo.tvGenres count]:[_filterInfo.movieGenres count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell"];
    BOOL isSelected = [[_filterInfo.recommendtvshows?_filterInfo.tvGenreSelected:_filterInfo.movieGenreSelected filteredArrayUsingPredicate:
                        [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",[_filterInfo.recommendtvshows?_filterInfo.tvGenres[indexPath.row]:_filterInfo.movieGenres[indexPath.row] objectForKey:@"name"]]] count]>0?YES:NO;
    if (isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [_filterInfo.recommendtvshows?_filterInfo.tvGenres[indexPath.row] :_filterInfo.movieGenres[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (IBAction)onYearChanged:(id)sender{
    UISlider *aSlider = (UISlider*)sender;
    _yearLabel.text = [NSString stringWithFormat:@"%d", (int)aSlider.value];
}

- (IBAction)onHighRateOnly:(id)sender {
    
}
- (IBAction)onRecommendTVShows:(id)sender {
    _filterInfo.recommendtvshows=_recommendtvshows.on;
    [_tbl_Genres reloadData];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return row_height;
}
- (IBAction)onDoneButton:(id)sender {
    _filterInfo.highrate_only=_highrate_only.on;
    _filterInfo.recommendtvshows=_recommendtvshows.on;
    _filterInfo.minYear=_yearSlider.value;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_filterInfo];
    NSNumber *number= [NSNumber numberWithBool:YES];
    @synchronized(data)
    {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"filterInfo"];
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"number"];
    }
    [Global DismissScene:self moveLeft:NO];
}
- (IBAction)onBackButton:(id)sender {
    [Global DismissScene:self moveLeft:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onRowClicked:tableView indexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)onRowClicked:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",(NSDictionary*)[_filterInfo.recommendtvshows?_filterInfo.tvGenres[indexPath.row]:_filterInfo.movieGenres [indexPath.row] objectForKey:@"name"]];
    BOOL isSelected = [[_filterInfo.recommendtvshows?_filterInfo.tvGenreSelected:_filterInfo.movieGenreSelected filteredArrayUsingPredicate:
                        predicate] count]>0?YES:NO;
    if (isSelected) {
        [_filterInfo.recommendtvshows?_filterInfo.tvGenreSelected:_filterInfo.movieGenreSelected
         removeObject:[_filterInfo.recommendtvshows?_filterInfo.tvGenres[indexPath.row]:_filterInfo.movieGenres [indexPath.row] objectForKey:@"name"]];
    }else{
        [ _filterInfo.recommendtvshows?_filterInfo.tvGenreSelected:_filterInfo.movieGenreSelected addObject:[_filterInfo.recommendtvshows?_filterInfo.tvGenres[indexPath.row]:_filterInfo.movieGenres[indexPath.row] objectForKey:@"name"]];
    }
    if (isSelected==NO) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onRowClicked:tableView indexPath:indexPath];
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

@end
