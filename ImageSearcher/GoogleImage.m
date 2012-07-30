//
//  GoogleImage.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import "GoogleImage.h"

@implementation GoogleImage

@synthesize content = _content;
@synthesize contentNoFormatting = _contentNoFormatting;
@synthesize height = _height;
@synthesize html = _html;
@synthesize originalContextURL = _originalContextURL;
@synthesize tbHeight = _tbHeight;
@synthesize tbUrl = _tbUrl;
@synthesize tbWidth = _tbWidth;
@synthesize title = _title;
@synthesize titleNoFormatting = _titleNoFormatting;
@synthesize unescapedUrl = _unescapedUrl;
@synthesize url = _url;
@synthesize visibleUrl = _visibleUrl;
@synthesize width = _width;

- (void)dealloc
{
    [self.content release];
    [self.contentNoFormatting release];
    [self.html release];
    [self.originalContextURL release];
    [self.tbUrl release];
    [self.title release];
    [self.titleNoFormatting release];
    [self.unescapedUrl release];
    [self.url release];
    [self.visibleUrl release];
    
    [super dealloc];
}

#pragma mark -

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
                  width:(NSString *)width
{
    self = [super init];
    if (self) {
        self.content = content;
        self.contentNoFormatting = contentNoFormatting;
        self.height = height;
        self.html = html;
        self.originalContextURL = originalContextURL;
        self.tbHeight = tbHeight;
        self.tbUrl = tbUrl;
        self.tbWidth = tbWidth;
        self.title = title;
        self.titleNoFormatting = titleNoFormatting;
        self.unescapedUrl = unescapedUrl;
        self.url = url;
        self.visibleUrl = visibleUrl;
        self.width = width;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Google Image\n\tTitle: %@\n\tContent: %@\n\tURL: %@\n\tHeight: %@\n\tWidth: %@\n\ttbURL: %@\n\ttbHeight: %@\n\ttbWidth: %@\n\n",
            self.title, self.content, self.unescapedUrl, self.height, self.width, self.tbUrl, self.tbHeight, self.tbWidth];
            
}


@end
