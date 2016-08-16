//
//  MyIndicatorView.m
//  MovieAdvisor2
//
//  Created by Mobile Dev on 2/10/15.
//  Copyright (c) 2015 MobileDev. All rights reserved.
//

#import "MyIndicatorView.h"

@implementation MyIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    /*for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }*/
    return NO;
}
@end
