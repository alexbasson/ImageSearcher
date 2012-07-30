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
#pragma mark -
#pragma mark Initializers

- (id)initWithQuery:(NSString *)query
{
    self = [super init];
    if (self) {
        self.queryString = query;
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
                                      [kGoogleImageSearchURL stringByAppendingFormat:@"rsz=%i&start=%i&q=%@", kResultSize, i*kResultSize, self.queryString]];
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
            [self.googleImages addObject:image];
            [image release];
        }
        NSLog(@"Number of images: %d", [self.googleImages count]); // This had better equal kResultSize * kNumberOfQueries
        dispatch_async(kMainQueue, ^{
            CGFloat x = 0.0f;
            CGFloat y = 0.0f;
            for (GoogleImage *image in self.googleImages) {
                UILazyImageView *imageView = [[UILazyImageView alloc] initWithURL:[NSURL URLWithString:image.unescapedUrl]];
                imageView.frame = CGRectMake(x, y, 200.0f, 200.0f);
                [self.containerView addSubview:imageView];
                [imageView release];
                if (x >= 600.0f) {
                    x = 0.0f;
                    y += 200.0f;
                } else {
                    x += 200.0f;
                }
            }
        });
    });
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


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queryStringLabel.text = self.queryString;
    [self fetchSearchResults];
    
    // Set up container view to hold images
    CGSize containerSize = CGSizeMake(800.0f, 1200.0f);
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
    [self.scrollView addSubview:self.containerView];
    [self.containerView release];
            
    self.scrollView.contentSize = containerSize;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self centerScrollViewContents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.queryStringLabel release];
    self.queryStringLabel = nil;
    
    [self.scrollView release];
    self.scrollView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [self.queryString release];
    [self.queryStringLabel release];
    [self.googleImages release];
    [self.scrollView release];
    [self.containerView release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
