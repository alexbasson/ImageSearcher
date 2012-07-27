//
//  SearchResultsViewController.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGoogleImageSearchURL @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&"

#import "SearchResultsViewController.h"
#import "GoogleImage.h"

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

@end

@implementation SearchResultsViewController

@synthesize queryString = _queryString;
@synthesize queryStringLabel = _queryStringLabel;
@synthesize searchResults = _searchResults;

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
        self.searchResults = [NSMutableArray arrayWithCapacity:24];
        for (NSUInteger i = 0; i < 3; i++) {
            NSString *searchQuery = [kGoogleImageSearchURL stringByAppendingFormat:@"start=%i&q=%@", i*8, self.queryString];
            NSLog(@"searchQuery: %@", searchQuery);
            NSDictionary *jsonData = [NSDictionary dictionaryWithContentsOfJSONURLString:[kGoogleImageSearchURL stringByAppendingFormat:@"start=%i&q=%@", i, self.queryString]];
            NSDictionary *results = [jsonData objectForKey:@"responseData"];
            [self.searchResults addObjectsFromArray:[results objectForKey:@"results"]];
        }
        NSLog(@"Number of images: %d", [self.searchResults count]);
        for (NSDictionary *result in self.searchResults) {
            NSLog(@"title: %@", [result objectForKey:@"title"]);
            NSLog(@"url: %@", [result objectForKey:@"url"]);
            NSLog(@"========");
        }
    });
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queryStringLabel.text = self.queryString;
    [self fetchSearchResults];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.queryStringLabel release];
    self.queryStringLabel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [self.queryString release];
    [self.queryStringLabel release];
    [self.searchResults release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
