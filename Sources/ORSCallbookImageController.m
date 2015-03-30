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
	return self.cache[callsign];
}

- (void)setImage:(UIImage *)image forCallsign:(NSString *)callsign
{
	if (!image) return;
	self.cache[callsign] = image;
}

- (void)fetchAndCacheImageAtURL:(NSURL *)url forCallsign:(NSString *)callsign completionBlock:(ORSCallbookImageControllerCompletionBlock)block
{
	if (!url) return;
	if (!block) block = ^(UIImage *i){};
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	__weak typeof(self) weakSelf = self;
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
