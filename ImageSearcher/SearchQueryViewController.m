//
//  SearchQueryViewController.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import "SearchQueryViewController.h"
#import "SearchResultsViewController.h"

@interface SearchQueryViewController ()

@end

@implementation SearchQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Google Image Search";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.query release];
    self.query = nil;
}

- (void)dealloc
{
    [_query release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)findImagesPressed:(id)sender
{
    SearchResultsViewController *searchResultsViewController = [[[SearchResultsViewController alloc] initWithQuery:[self.query text]] autorelease];
    [[self navigationController] pushViewController:searchResultsViewController animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

@end
