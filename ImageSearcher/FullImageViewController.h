//
//  FullImageViewController.h
//  ImageSearcher
//
//  Created by Alex on 8/1/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImageViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithImageURL:(NSURL *)theURL;

@end
