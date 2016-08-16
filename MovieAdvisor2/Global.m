//
//  Global.m
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/7/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import "Global.h"

@implementation Global
+(void)ChangeScene:(UIViewController*) currentViewController storyboard_id:(NSString *)storyboard_id moveLeft:(BOOL) moveLeft{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    if (moveLeft) {
        transition.subtype = kCATransitionFromRight;
    }else
        transition.subtype = kCATransitionFromLeft;
    
    [currentViewController.view.window.layer addAnimation:transition forKey:nil];
    
    UIViewController *newViewController=[currentViewController.storyboard instantiateViewControllerWithIdentifier:storyboard_id];
    
    [currentViewController presentViewController:newViewController animated:NO completion:nil];
}

+(void)DismissScene:(UIViewController*) currentViewController moveLeft:(BOOL) moveLeft{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    if (moveLeft) {
        transition.subtype = kCATransitionFromRight;
    }else
        transition.subtype = kCATransitionFromLeft;
    
    [currentViewController.view.window.layer addAnimation:transition forKey:nil];
    [currentViewController dismissViewControllerAnimated:NO completion:nil];
}

@end
