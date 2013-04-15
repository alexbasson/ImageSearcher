//
//  SearchResultsViewController.h
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABScrollView.h"

@protocol SearchResultsViewControllerDelegate;

@interface SearchResultsViewController : UIViewController <UIScrollViewDelegate>
{
    id <SearchResultsViewControllerDelegate> delegate;
}

@property (nonatomic,assign) id <SearchResultsViewControllerDelegate> delegate;


@property (copy, nonatomic) NSString *queryString;
@property (strong, nonatomic) IBOutlet UILabel *queryStringLabel;
@property (strong, nonatomic) NSMutableArray *googleImages;

@property (strong, nonatomic) IBOutlet ABScrollView *scrollView;

- (id)initWithQuery:(NSString *)query;

@end

@protocol SearchResultsViewControllerDelegate <NSObject>
@required
@optional
- (void)searchResultViewController:(SearchResultsViewController *)controller image:(UIImage*)image;
@end