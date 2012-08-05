//
//  ABScrollView.m
//  ImageSearcher
//
//  Created by Alex on 8/5/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import "ABScrollView.h"

@implementation ABScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isMemberOfClass:[UIButton class]]) {
        return YES;
    } else {
        return [super touchesShouldCancelInContentView:view];
    }
}

@end
