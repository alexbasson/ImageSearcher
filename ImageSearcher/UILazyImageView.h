//
//  UILazyImageView.h
//  ImageSearcher
//
//  Created by Alex Basson on 7/29/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleImage.h"

@interface UILazyImageView : UIImageView {
    NSMutableData *receivedData;
}

- (id)initWithURL:(NSURL *)url;
- (void)loadWithURL:(NSURL *)url;

@end
