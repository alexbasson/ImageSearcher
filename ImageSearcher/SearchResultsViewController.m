//
//  SearchResultsViewController.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGoogleImageSearchURL @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&"

// The total number of images returned will be the product of kResultSize and kNumberOfQueries
#define kResultSize 8
#define kNumberOfQueries 3

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
@synthesize googleImages = _googleImages;

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
            NSLog(@"%@", image);
            [image release];
        }
        NSLog(@"Number of images: %d", [self.googleImages count]); // This had better equal kResultSize * kNumberOfQueries
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
    [self.googleImages release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
