//
//  GoogleImage.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/25/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import "GoogleImage.h"

@implementation GoogleImage

- (void)dealloc
{
    [_content release];
    [_contentNoFormatting release];
    [_html release];
    [_originalContextURL release];
    [_tbUrl release];
    [_title release];
    [_titleNoFormatting release];
    [_unescapedUrl release];
    [_url release];
    [_visibleUrl release];
    
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
        _content = [content retain];
        _contentNoFormatting = [contentNoFormatting retain];
        _height = [height retain];
        _html = [html retain];
        _originalContextURL = [originalContextURL retain];
        _tbHeight = [tbHeight retain];
        _tbUrl = [tbUrl retain];
        _tbWidth = [tbWidth retain];
        _title = [title retain];
        _titleNoFormatting = [titleNoFormatting retain];
        _unescapedUrl = [unescapedUrl retain];
        _url = [url retain];
        _visibleUrl = [visibleUrl retain];
        _width = [width retain];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Google Image\n\tTitle: %@\n\tContent: %@\n\tURL: %@\n\tHeight: %@\n\tWidth: %@\n\ttbURL: %@\n\ttbHeight: %@\n\ttbWidth: %@\n\n",
            self.title, self.content, self.unescapedUrl, self.height, self.width, self.tbUrl, self.tbHeight, self.tbWidth];
            
}


@end
