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

#pragma mark -
#pragma mark Setters

- (void)setHeight:(id)height
{
    if ([height isMemberOfClass:[NSString class]]) {
        _height = [NSNumber numberWithInteger:[height integerValue]];
    }
    else if ([height isMemberOfClass:[NSNumber class]]) {
        _height = height;
    }
    else {
        return;
    }
}

- (void)setWidth:(id)width
{
    if ([width isMemberOfClass:[NSString class]]) {
        _width = [NSNumber numberWithInteger:[width integerValue]];
    }
    else if ([width isMemberOfClass:[NSNumber class]]) {
        _width = width;
    }
    else {
        return;
    }
}

- (void)setTbHeight:(id)height
{
    if ([height isMemberOfClass:[NSString class]]) {
        _tbHeight = [NSNumber numberWithInteger:[height integerValue]];
    }
    else if ([height isMemberOfClass:[NSNumber class]]) {
        _tbHeight = height;
    }
    else {
        return;
    }
}

- (void)setTbWidth:(id)width
{
    if ([width isMemberOfClass:[NSString class]]) {
        _tbWidth = [NSNumber numberWithInteger:[width integerValue]];
    }
    else if ([width isMemberOfClass:[NSNumber class]]) {
        _tbWidth = width;
    }
    else {
        return;
    }
}

- (void)setOriginalContextURL:(id)url
{
    if ([url isMemberOfClass:[NSString class]]) {
        _originalContextURL = [NSURL URLWithString:url];
    }
    else if ([url isMemberOfClass:[NSURL class]]) {
        _originalContextURL = url;
    }
    else {
        return;
    }
}

- (void)setTbUrl:(id)url
{
    if ([url isMemberOfClass:[NSString class]]) {
        _tbUrl = [NSURL URLWithString:url];
    }
    else if ([url isMemberOfClass:[NSURL class]]) {
        _tbUrl = url;
    }
    else {
        return;
    }
}

- (void)setUrl:(id)url
{
    if ([url isMemberOfClass:[NSString class]]) {
        _url = [NSURL URLWithString:url];
    }
    else if ([url isMemberOfClass:[NSURL class]]) {
        _url = url;
    }
    else {
        return;
    }
}

- (void)setUnescapedUrl:(id)url
{
    if ([url isMemberOfClass:[NSString class]]) {
        _unescapedUrl = [NSURL URLWithString:url];
    }
    else if ([url isMemberOfClass:[NSURL class]]) {
        _unescapedUrl = url;
    }
    else {
        return;
    }
}

- (void)setVisibleUrl:(id)url
{
    if ([url isMemberOfClass:[NSString class]]) {
        _visibleUrl = [NSURL URLWithString:url];
    }
    else if ([url isMemberOfClass:[NSURL class]]) {
        _visibleUrl = url;
    }
    else {
        return;
    }
}




#pragma mark -
# pragma mark Lifecycle

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

@end
