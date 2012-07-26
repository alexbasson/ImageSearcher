//
//  GoogleImage.h
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleImage : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *contentNoFormatting;
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) NSString *html;
@property (strong, nonatomic) NSURL *originalContextURL;
@property (strong, nonatomic) NSNumber *tbHeight;
@property (strong, nonatomic) NSURL *tbUrl;
@property (strong, nonatomic) NSNumber *tbWidth;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *titleNoFormatting;
@property (strong, nonatomic) NSURL *unescapedUrl;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *visibleUrl;
@property (strong, nonatomic) NSNumber *width;


@end
