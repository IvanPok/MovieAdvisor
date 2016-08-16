//
//  CriteriaViewController.h
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/7/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterInfo.h"
#import "Global.h"

@interface CriteriaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    float row_height;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_Genres;
@property (nonatomic, strong) FilterInfo *filterInfo;
@property (weak, nonatomic) IBOutlet UISwitch *highrate_only;
@property (weak, nonatomic) IBOutlet UISwitch *recommendtvshows;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UISlider *yearSlider;


@end
