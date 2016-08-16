//
//  WatchLaterViewController.m
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/9/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import "WatchLaterViewController.h"

@implementation WatchLaterViewController

-(void)viewDidLoad{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"WatchLater"];
    _watchLaterList=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    _keyArray=[_watchLaterList.watchlater_list allKeys];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.width*0.5f;
}
- (IBAction)onBack:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SelectedWatchLater"];
    [[NSUserDefaults standardUserDefaults] setObject:0 forKey:@"number"];
    [Global DismissScene:self moveLeft:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"WatchLaterCell";
    
    WatchLaterCell *cell = (WatchLaterCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    WatchLaterItem *watchLaterItem=[_watchLaterList.watchlater_list objectForKey:[_keyArray objectAtIndex:indexPath.row]];
    
    cell.lbl_Title.text=watchLaterItem.title;
    cell.lbl_Year.text=watchLaterItem.year;
    cell.lbl_Genres.text=watchLaterItem.genres;
    cell.lbl_Rating.text=watchLaterItem.rate;
    cell.lbl_Duration.text=watchLaterItem.time;
    cell.img_Post.image=nil;
    if (watchLaterItem.is_tvshows.intValue>0) {
        [cell.img_tvshows setHidden:NO];
    }else{
        [cell.img_tvshows setHidden:YES];
    }
    cell.lbl_Title.backgroundColor=[UIColor clearColor];
    cell.lbl_Year.backgroundColor=[UIColor clearColor];
    cell.lbl_Genres.backgroundColor=[UIColor clearColor];
    cell.lbl_Rating.backgroundColor=[UIColor clearColor];
    cell.lbl_Duration.backgroundColor=[UIColor clearColor];
    cell.img_url=[NSString stringWithString:watchLaterItem.img_url];
    [self performSelectorInBackground:@selector(ImageLoading:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil]];

   /* if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.nameLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    cell.prepTimeLabel.text = [prepTime objectAtIndex:indexPath.row];*/
    
    return cell;
}

-(void)ImageLoading:(NSDictionary*)dictionary{
    WatchLaterCell *cell=[dictionary objectForKey:@"cell"];
    NSString *img_url=cell.img_url;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    if (![img_url isEqualToString:cell.img_url] ) {
        return;
    }
    cell.img_Post.image = img;
}

- (IBAction)onEdit:(id)sender {
    if ([_btn_Edit.titleLabel.text isEqualToString:@"Done"]) {
        [_btn_Edit setTitle:@"Edit" forState:UIControlStateNormal];
        [_tbl_Content setEditing:NO animated:YES];
        return;
    }
    [_tbl_Content setEditing:YES animated:YES];
    [_btn_Edit setTitle:@"Done" forState:UIControlStateNormal];
//    [_btn_Edit setEnabled:NO];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger count = [_keyArray count];
    
    if (row < count) {
        [_watchLaterList.watchlater_list removeObjectForKey:[_keyArray objectAtIndex:row]];
        _keyArray=[_watchLaterList.watchlater_list allKeys];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_watchLaterList];
    @synchronized(data)
    {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"WatchLater"];
    }
    [tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (aTableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[_watchLaterList.watchlater_list objectForKey:[_keyArray objectAtIndex:indexPath.row]]];
    [[NSUserDefaults standardUserDefaults] setObject:[_keyArray objectAtIndex:indexPath.row] forKey:@"SelectedWatchLater"];
    [Global DismissScene:self moveLeft:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_keyArray count];
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
