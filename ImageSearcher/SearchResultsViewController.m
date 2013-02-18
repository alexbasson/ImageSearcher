//
//  SearchResultsViewController.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kMainQueue dispatch_get_main_queue()
#define kGoogleImageSearchURL @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&"

// The total number of images returned will be the product of kResultSize and kNumberOfQueries
#define kResultSize 8
#define kNumberOfQueries 3

#import "SearchResultsViewController.h"
#import "GoogleImage.h"
#import "UILazyImageView.h"
#import "FullImageViewController.h"

@interface NSDictionary(JSONCategories)
+ (NSDictionary *)dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress;
@end

@implementation NSDictionary(JSONCategories)
+ (NSDictionary *)dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAddress]];
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end

@interface SearchResultsViewController ()
@property (nonatomic, strong) UIView *containerView;

- (void)centerScrollViewContents;
@end

@implementation SearchResultsViewController

- (void)dealloc
{
    [_queryString release];
    [_queryStringLabel release];
    [_googleImages release];
    [_scrollView release];
    [_containerView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Initializers

- (id)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        _queryString = [query retain];
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

#pragma mark -
#pragma mark Instance Methods

- (void)fetchSearchResults
{
    dispatch_async(kBgQueue, ^{
        self.googleImages = [NSMutableArray arrayWithCapacity:kResultSize*kNumberOfQueries];
        NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:kResultSize*kNumberOfQueries];
        for (NSUInteger i = 0; i < kNumberOfQueries; i++) {
            NSDictionary *jsonData = [NSDictionary dictionaryWithContentsOfJSONURLString:
                                      [kGoogleImageSearchURL stringByAppendingFormat:@"rsz=%i&start=%i&q=%@", kResultSize, i*kResultSize, [self queryString]]];
            NSDictionary *results = jsonData[@"responseData"];
            [searchResults addObjectsFromArray:results[@"results"]];
        }
        for (NSDictionary *result in searchResults) {
            GoogleImage *image = [[GoogleImage alloc] initWithContent:result[@"content"]
                                                  contentNoFormatting:result[@"contentNoFormatting"]
                                                               height:result[@"height"]
                                                                 html:result[@"html"]
                                                 origininalContextURL:result[@"originalContextUrl"]
                                                             tbHeight:result[@"tbHeight"]
                                                                tbURL:result[@"tbUrl"]
                                                              tbWidth:result[@"tbWidth"]
                                                                title:result[@"title"]
                                                    titleNoFormatting:result[@"titleNoFormatting"]
                                                         unescapedUrl:result[@"unescapedUrl"]
                                                                  url:result[@"url"]
                                                           visibleUrl:result[@"visibleUrl"]
                                                                width:result[@"width"]];
            [self.googleImages addObject:image];
            [image release];
        }
        NSLog(@"Number of images: %d", [self.googleImages count]); // This had better equal kResultSize * kNumberOfQueries
        dispatch_async(kMainQueue, ^{
            [self displayImages];
        });
    });
}

// Determine which images to display based on where scrollView is relative to containerView.
- (void)displayImages
{
    // Any point within xMin and xMax, yMin and yMax, is onscreen
    CGFloat xMin = self.scrollView.bounds.origin.x;
    CGFloat yMin = self.scrollView.bounds.origin.y;
    CGFloat xMax = xMin + self.scrollView.bounds.size.width;
    CGFloat yMax = yMin + self.scrollView.bounds.size.height;
    BOOL (^imageFrameIsOnscreen)(CGPoint) = ^(CGPoint frameOrigin) {        
        return (BOOL)(frameOrigin.x >= xMin - 200.0f && frameOrigin.x <= xMax && frameOrigin.y >= yMin - 200.0f && frameOrigin.y <= yMax);
    };
        
    // Remove any subviews that aren't onscreen
    for (UIView *imageView in self.containerView.subviews) {
        if (!imageFrameIsOnscreen(imageView.frame.origin)) {
            NSLog(@"Unloading image.");
            [imageView removeFromSuperview];
        }
    }
    
    BOOL (^imageAtArrayIndexIsAlreadyOnscreen)(NSUInteger) = ^(NSUInteger arrayIndex) {
        BOOL isOnscreen = NO;
        for (UIView *imageView in self.containerView.subviews) {
            NSUInteger xx = (NSUInteger)imageView.frame.origin.x;
            NSUInteger yy = (NSUInteger)imageView.frame.origin.y;
            if (arrayIndex == (yy / 200) * 4 + (xx / 200)) {
                isOnscreen = YES;
            }
        }
        return isOnscreen;        
    };
    
    for (NSUInteger i = 0; i < [self.googleImages count]; i++) {
        CGFloat x = (i % 4) * 200.0;
        CGFloat y = (i / 4) * 200.0;
        if (imageFrameIsOnscreen(CGPointMake(x, y)) && !imageAtArrayIndexIsAlreadyOnscreen(i)) {
            GoogleImage *googleImage = self.googleImages[i];
            UILazyImageView *imageView = [[UILazyImageView alloc] initWithURL:[NSURL URLWithString:googleImage.tbUrl]];
            imageView.frame = CGRectMake(x, y, 200.0f, 200.0f);
            
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(0, 0, 200.0f, 200.0f);
            [imageButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:imageButton];
            
            imageView.userInteractionEnabled = YES;
            
            [self.containerView addSubview:imageView];
            [imageView release];

        }
    }
}

- (void)centerScrollViewContents
{
    CGSize boundSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundSize.width) {
        contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundSize.height) {
        contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}

- (void)imageTapped:(id)sender
{
    UIView *imageView = [sender superview];
    // Get the index of sender in the googleImages array
    NSUInteger xx = (NSUInteger)imageView.frame.origin.x;
    NSUInteger yy = (NSUInteger)imageView.frame.origin.y;
    NSUInteger index = (yy / 200) * 4 + (xx / 200);
    GoogleImage *googleImage = self.googleImages[index];
    FullImageViewController *fullImageViewController = [[[FullImageViewController alloc] initWithImageURL:[NSURL URLWithString:googleImage.unescapedUrl]] autorelease];
    [self.navigationController pushViewController:fullImageViewController animated:YES];
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queryStringLabel.text = self.queryString;
    [self fetchSearchResults];
    
    // Set up container view to hold images
    CGSize containerSize = CGSizeMake(800.0f, 1200.0f);
    [self setContainerView:[[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}]];
    [self.scrollView addSubview:self.containerView];
    [self.containerView release];
    
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.contentSize = containerSize;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self centerScrollViewContents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[self queryStringLabel] release];
    self.queryStringLabel = nil;
    
    [[self scrollView] release];
    self.scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self displayImages];
}

@end
