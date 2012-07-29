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
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *html;
@property (strong, nonatomic) NSString *originalContextURL;
@property (strong, nonatomic) NSString *tbHeight;
@property (strong, nonatomic) NSString *tbUrl;
@property (strong, nonatomic) NSString *tbWidth;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *titleNoFormatting;
@property (strong, nonatomic) NSString *unescapedUrl;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *visibleUrl;
@property (strong, nonatomic) NSString *width;


- (id)initWithContent:(NSString *)content
    contentNoFormatting:(NSString *)contentNoFormatting
                 height:(NSString *)height
                   html:(NSString *)html
   origininalContextURL:(NSString *)originalContextURL
               tbHeight:(NSString *)tbHeight
                  tbURL:(NSString *)tbUrl
                tbWidth:(NSString *)tbWidth
                  title:(NSString *)title
      titleNoFormatting:(NSString *)titleNoFormatting
           unescapedUrl:(NSString *)unescapedUrl
                    url:(NSString *)url
             visibleUrl:(NSString *)visibleUrl
                  width:(NSString *)width;


@end
