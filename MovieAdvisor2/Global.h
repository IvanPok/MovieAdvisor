//
//  Global.h
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/7/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Global : NSObject

+(void)ChangeScene:(UIViewController*) currentViewController storyboard_id:(NSString *)storyboard_id moveLeft:(BOOL) moveLeft;
+(void)DismissScene:(UIViewController*) currentViewController moveLeft:(BOOL) moveLeft;
@end
