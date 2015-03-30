//
//  ORSCallbookImageCache.m
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ORSCallbookImageController.h"

@interface ORSCallbookImageController ()

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation ORSCallbookImageController

+ (instancetype)sharedCache
{
	static ORSCallbookImageController *sharedCache = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedCache = [[self alloc] init];
	});
	return sharedCache;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		_cache = [NSMutableDictionary dictionary];
	}
	return self;
}

#pragma mark - Public

- (UIImage *)imageForCallsign:(NSString *)callsign
{
	NSData *data = self.cache[callsign];
	if (!data) return nil;
	return [UIImage imageWithData:data];
}

- (void)setImage:(UIImage *)image forCallsign:(NSString *)callsign
{
	if (!image) return;
	CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
	CFDataRef cfData = CGDataProviderCopyData(provider);
	self.cache[callsign] = (__bridge NSData *)cfData;
}

- (void)fetchAndCacheImageAtURL:(NSURL *)url forCallsign:(NSString *)callsign completionBlock:(ORSCallbookImageControllerCompletionBlock)block
{
	if (!url) return;
	if (!block) block = ^(UIImage *i){};
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	__weak typeof(self) weakSelf = self;
	[[[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
		NSData *data = [NSData dataWithContentsOfURL:location];
		if (!data) {
			NSLog(@"Unable to get image from %@: %@", url, error);
			block(nil);
			return;
		}
		UIImage *image = [UIImage imageWithData:data];
		[weakSelf setImage:image forCallsign:callsign];
		block(image);
	}] resume];
}

@end
