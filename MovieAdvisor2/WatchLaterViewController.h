//
//  WatchLaterViewController.h
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/9/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchLaterCell.h"
#import "WatchLaterList.h"
#import "Global.h"
@interface WatchLaterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn_Back;
@property (weak, nonatomic) IBOutlet UIButton *btn_Edit;
@property (weak, nonatomic) IBOutlet UITableView *tbl_Content;
@property WatchLaterList * watchLaterList;
@property NSArray * keyArray;
@end
