//
//  ViewController.h
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/6/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "Global.h"
#import "CriteriaViewController.h"
#import "WatchLaterList.h"
#import "GADBannerView.h"


typedef void (^ResponseCallback)(NSDictionary* response, NSError *error);

@interface ViewController : UIViewController

//UI Controls
@property (weak, nonatomic) IBOutlet UIImageView *img_post;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *foreScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Year;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *RateStar;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoVideo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoImage;
@property (weak, nonatomic) IBOutlet YTPlayerView *trailerPlayer;
@property (weak, nonatomic) IBOutlet UIButton *btn_Play;
@property (weak, nonatomic) IBOutlet UITextView *txt_Casting;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ForeScrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *txt_Director;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CastingTextHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *txt_Description;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DescriptionTextHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddToWatchLaterDescription;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddToWatchLaterButton;
@property (weak, nonatomic) IBOutlet UIView *view_Director;
@property (weak, nonatomic) IBOutlet UILabel *lbl_AddToWatchLater;
@property (weak, nonatomic) IBOutlet UILabel *lbl_MovieTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Genres;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Duration;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Rating;

//Members
@property (nonatomic, strong) FilterInfo *filterInfo;
@property (nonatomic, strong) WatchLaterList * watchLaterList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property NSString *movie_id;
@property NSString *img_url;
@property NSString *video_id;
@end

