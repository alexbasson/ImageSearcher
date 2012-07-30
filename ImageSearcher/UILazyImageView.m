//
//  UILazyImageView.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/29/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import "UILazyImageView.h"
#import "NSString+MD5.h"

@interface UILazyImageView()
@property (strong, nonatomic) NSURL *imageFileURL;
@end

@implementation UILazyImageView

@synthesize imageFileURL = _imageFileURL;

- (void)dealloc
{
    [receivedData release];
    [_imageFileURL release];
    
    [super dealloc];
}

- (id)initWithURL:(NSURL *)url
{
    self = [self init];
    
    if (self) {
        __autoreleasing NSError *error = nil;
        [self setImageFileURL:[[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                    inDomain:NSUserDomainMask
                                                           appropriateForURL:nil
                                                                      create:NO
                                                                       error:&error]
                             URLByAppendingPathComponent:[[url absoluteString] MD5]]];
        [self setAlpha:0.0];
        if ([[self imageFileURL] isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath:[[self imageFileURL] path]]) {
            NSLog(@"Loading image from disk.");
            [self setImage:[[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[self imageFileURL]]] autorelease]];
            [self fadeInImage];
        } else {
            NSLog(@"Loading image from internet.");
            receivedData = [[NSMutableData data] retain];
            [self loadWithURL:url];
        }
    }
    
    return self;
}

- (void)loadWithURL:(NSURL *)url
{
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    [connection start];
}

- (void)fadeInImage
{
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:0.5];
    [self setAlpha:1.0];
    [UIView commitAnimations];
}


#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self setImage:[[UIImage alloc] initWithData:receivedData]];
    [receivedData writeToURL:[self imageFileURL] atomically:YES];
    [receivedData release];
    receivedData = nil;
    [self fadeInImage];
}


@end
