//
//  SearchResultsViewController.h
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSString *queryString;
@property (strong, nonatomic) IBOutlet UILabel *queryStringLabel;
@property (strong, nonatomic) NSMutableArray *googleImages;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithQuery:(NSString *)query;

@end
