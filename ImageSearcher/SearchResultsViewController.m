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

@synthesize queryString = _queryString;
@synthesize queryStringLabel = _queryStringLabel;
@synthesize googleImages = _googleImages;
@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;

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
        [self setGoogleImages:[NSMutableArray arrayWithCapacity:kResultSize*kNumberOfQueries]];
        NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:kResultSize*kNumberOfQueries];
        for (NSUInteger i = 0; i < kNumberOfQueries; i++) {
            NSDictionary *jsonData = [NSDictionary dictionaryWithContentsOfJSONURLString:
                                      [kGoogleImageSearchURL stringByAppendingFormat:@"rsz=%i&start=%i&q=%@", kResultSize, i*kResultSize, [self queryString]]];
            NSDictionary *results = [jsonData objectForKey:@"responseData"];
            [searchResults addObjectsFromArray:[results objectForKey:@"results"]];
        }
        for (NSDictionary *result in searchResults) {
            GoogleImage *image = [[GoogleImage alloc] initWithContent:[result objectForKey:@"content"]
                                                  contentNoFormatting:[result objectForKey:@"contentNoFormatting"]
                                                               height:[result objectForKey:@"height"]
                                                                 html:[result objectForKey:@"html"]
                                                 origininalContextURL:[result objectForKey:@"originalContextUrl"]
                                                             tbHeight:[result objectForKey:@"tbHeight"]
                                                                tbURL:[result objectForKey:@"tbUrl"]
                                                              tbWidth:[result objectForKey:@"tbWidth"]
                                                                title:[result objectForKey:@"title"]
                                                    titleNoFormatting:[result objectForKey:@"titleNoFormatting"]
                                                         unescapedUrl:[result objectForKey:@"unescapedUrl"]
                                                                  url:[result objectForKey:@"url"]
                                                           visibleUrl:[result objectForKey:@"visibleUrl"]
                                                                width:[result objectForKey:@"width"]];
            [[self googleImages] addObject:image];
            [image release];
        }
        NSLog(@"Number of images: %d", [[self googleImages] count]); // This had better equal kResultSize * kNumberOfQueries
        dispatch_async(kMainQueue, ^{
            [self displayImages];
        });
    });
}

// Determine which images to display based on where scrollView is relative to containerView.
- (void)displayImages
{
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    // Any point within xMin and xMax, yMin and yMax, is onscreen
    CGFloat xMin = [[self scrollView] bounds].origin.x;
    CGFloat yMin = [[self scrollView] bounds].origin.y;
    CGFloat xMax = xMin + [[self scrollView] bounds].size.width;
    CGFloat yMax = yMin + [[self scrollView] bounds].size.height;
    BOOL (^imageFrameIsOnscreen)(CGPoint) = ^(CGPoint frameOrigin) {        
        return (BOOL)(frameOrigin.x >= xMin - 200.0f && frameOrigin.x <= xMax && frameOrigin.y >= yMin - 200.0f && frameOrigin.y <= yMax);
    };
        
    // Remove any subviews that aren't onscreen
    for (UIView *imageView in [[self containerView] subviews]) {
        if (!imageFrameIsOnscreen([imageView frame].origin)) {
            NSLog(@"Unloading image.");
            [imageView removeFromSuperview];
        }
    }
    
    BOOL (^imageAtArrayIndexIsAlreadyLoaded)(NSUInteger) = ^(NSUInteger arrayIndex) {
        BOOL isOnscreen = NO;
        for (UIView *imageView in [[self containerView] subviews]) {
            NSUInteger x = (NSUInteger)imageView.frame.origin.x;
            NSUInteger y = (NSUInteger)imageView.frame.origin.y;
            if (arrayIndex == (y / 200) * 4 + (x / 200)) {
                isOnscreen = YES;
            }
        }
        return isOnscreen;        
    };
    
    for (GoogleImage *image in [self googleImages]) {
        if (imageFrameIsOnscreen(CGPointMake(x, y)) && !imageAtArrayIndexIsAlreadyLoaded([[self googleImages] indexOfObject:image])) {
            UILazyImageView *imageView = [[UILazyImageView alloc] initWithURL:[NSURL URLWithString:[image unescapedUrl]]];
            [imageView setFrame:CGRectMake(x, y, 200.0f, 200.0f)];
            [[self containerView] addSubview:imageView];
            [imageView release];            
        }
        if (x >= 600.0f) {
            x = 0.0f;
            y += 200.0f;
        } else {
            x += 200.0f;
        }
    }
}

- (void)centerScrollViewContents
{
    CGSize boundSize = [[self scrollView] bounds].size;
    CGRect contentsFrame = [[self containerView] frame];
    
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
    
    [[self containerView] setFrame:contentsFrame];
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self queryStringLabel] setText:[self queryString]];
    [self fetchSearchResults];
    
    // Set up container view to hold images
    CGSize containerSize = CGSizeMake(800.0f, 1200.0f);
    [self setContainerView:[[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}]];
    [[self scrollView] addSubview:[self containerView]];
    [[self containerView] release];
            
    [[self scrollView] setContentSize:containerSize];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self centerScrollViewContents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[self queryStringLabel] release];
    [self setQueryStringLabel:nil];
    
    [[self scrollView] release];
    [self setScrollView:nil];
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
