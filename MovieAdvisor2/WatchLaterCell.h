//
//  WatchLaterCell.h
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/10/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchLaterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_Post;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Year;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Genres;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Duration;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Rating;
@property (weak, nonatomic) IBOutlet UIImageView *img_tvshows;
@property NSString *img_url;


@end
