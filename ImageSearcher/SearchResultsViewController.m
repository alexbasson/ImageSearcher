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
    urlAddress = [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
@synthesize delegate;

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
            [self displayImages:NO];
        });
    });
}

// Determine which images to display based on where scrollView is relative to containerView.
- (void)displayImages:(BOOL)force
{
    // Any point within xMin and xMax, yMin and yMax, is onscreen
    CGFloat xMin = self.scrollView.bounds.origin.x;
    CGFloat yMin = self.scrollView.bounds.origin.y;
    CGFloat xMax = xMin + self.scrollView.bounds.size.width;
    CGFloat yMax = yMin + self.scrollView.bounds.size.height;
    BOOL (^imageFrameIsOnscreen)(CGPoint) = ^(CGPoint frameOrigin) {
        float det = [[UIScreen mainScreen] bounds].size.width/4.0f;
        return (BOOL)(frameOrigin.x >= xMin - det && frameOrigin.x <= xMax && frameOrigin.y >= yMin - det && frameOrigin.y <= yMax);
    };
        
    // Remove any subviews that aren't onscreen
    for (UIView *imageView in self.containerView.subviews) {
        if (!imageFrameIsOnscreen(imageView.frame.origin) || force==YES) {
            NSLog(@"Unloading image.");
            [imageView removeFromSuperview];
        }
    }
    
    BOOL (^imageAtArrayIndexIsAlreadyOnscreen)(NSUInteger) = ^(NSUInteger arrayIndex) {
        BOOL isOnscreen = NO;
        for (UIView *imageView in self.containerView.subviews) {
            NSUInteger xx = (NSUInteger)imageView.frame.origin.x;
            NSUInteger yy = (NSUInteger)imageView.frame.origin.y;
            float det = [[UIScreen mainScreen] bounds].size.width/4.0f;
            if (arrayIndex == (yy / det) * 4 + (xx / det)) {
                isOnscreen = YES;
            }
        }
        return isOnscreen;        
    };
    
    for (NSUInteger i = 0; i < [self.googleImages count]; i++) {
        float det = [[UIScreen mainScreen] bounds].size.width/4.0f;
        CGFloat x = (i % 4) * det;
        CGFloat y = (i / 4) * det;
        if (imageFrameIsOnscreen(CGPointMake(x, y)) && !imageAtArrayIndexIsAlreadyOnscreen(i)) {
            GoogleImage *googleImage = self.googleImages[i];
            UILazyImageView *imageView = [[UILazyImageView alloc] initWithURL:[NSURL URLWithString:googleImage.tbUrl]];
            imageView.frame = CGRectMake(x, y, det, det);
            
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(0, 0, det, det);
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
    float det = [[UIScreen mainScreen] bounds].size.width/4.0f;
    NSUInteger index = (yy / det) * 4 + (xx / det);
    GoogleImage *googleImage = self.googleImages[index];
    NSLog(@"url [%@][%@]",googleImage.unescapedUrl,googleImage.tbUrl);
    if([delegate respondsToSelector:@selector(searchResultViewController:url:)]) {
        [delegate searchResultViewController:self url:googleImage.unescapedUrl];
    }
    
    if([delegate respondsToSelector:@selector(searchResultViewControllerDidFinished:)]) {
        [delegate searchResultViewControllerDidFinished:self];
    }
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queryStringLabel.text = self.queryString;
    [self fetchSearchResults];
    
    [searchBar becomeFirstResponder];
    
    // Set up container view to hold images
    float det = [[UIScreen mainScreen] bounds].size.width/4.0f;
    CGSize containerSize = CGSizeMake(det*4, det*6);
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
    [self displayImages:NO];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.queryString = [searchText retain];
    self.queryStringLabel.text = self.queryString;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)sBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)sBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
    [self fetchSearchResults];
    [searchBar resignFirstResponder];
    [self displayImages:YES];
    [self.scrollView setNeedsDisplay];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton =NO;
    if([delegate respondsToSelector:@selector(searchResultViewControllerDidFinished:)]) {
        [delegate searchResultViewControllerDidFinished:self];
    }
}

@end
