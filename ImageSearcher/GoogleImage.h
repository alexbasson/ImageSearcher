//
//  GoogleImage.h
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleImage : NSObject

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *contentNoFormatting;
@property (copy, nonatomic) NSString *height;
@property (copy, nonatomic) NSString *html;
@property (copy, nonatomic) NSString *originalContextURL;
@property (copy, nonatomic) NSString *tbHeight;
@property (copy, nonatomic) NSString *tbUrl;
@property (copy, nonatomic) NSString *tbWidth;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *titleNoFormatting;
@property (copy, nonatomic) NSString *unescapedUrl;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *visibleUrl;
@property (copy, nonatomic) NSString *width;


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
