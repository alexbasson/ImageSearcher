//
//  FullImageViewController.m
//  ImageSearcher
//
//  Created by Alex on 8/1/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//
#define kMainQueue dispatch_get_main_queue()

#import "FullImageViewController.h"
#import "UILazyImageView.h"

@interface FullImageViewController ()
@property (strong, nonatomic) UIImageView *imageView;

- (void)centerScrollViewContents;
/*
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer;
*/
@end

@implementation FullImageViewController

- (void)dealloc
{
    [_imageURL release];
    [_scrollView release];
    [_imageView release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self.scrollView release];
    self.scrollView = nil;
}

#pragma mark - Initializers

- (id)initWithImageURL:(NSURL *)theURL
{
    self = [self init];
    
    if (self) {
        _imageURL = [theURL retain];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidZoom: called.");
    [self centerScrollViewContents];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(kMainQueue, ^{
        UIImageView *lazyImageView = [[UILazyImageView alloc] initWithURL:[self imageURL]];
        self.imageView = lazyImageView;
        [lazyImageView release];
        self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=[[[self imageView] image] size]};
        [self.scrollView addSubview:self.imageView];
        self.scrollView.contentSize = self.imageView.image.size;
        [self centerScrollViewContents];
    });

    
    /*
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    [doubleTapRecognizer release];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired: = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    [twoFingerTapRecognizer release];
    */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

#pragma mark - Instance methods

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

/*
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, [[self scrollView] maximumZoomScale]);
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    [self.scrollView zoomToRect:CGRectMake(x, y, w, h) animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer
{
    // Zoom out slightly, capping at the minimum zoom scale specifie by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, [self.scrollView minimumZoomScale]);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
