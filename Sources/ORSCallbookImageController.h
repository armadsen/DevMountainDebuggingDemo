//
//  ORSCallbookImageCache.h
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

@import UIKit;

typedef void(^ORSCallbookImageControllerCompletionBlock)(UIImage *image);

@interface ORSCallbookImageController : NSObject

+ (instancetype)sharedCache;

- (UIImage *)imageForCallsign:(NSString *)callsign;
- (void)setImage:(UIImage *)image forCallsign:(NSString *)callsign;

- (void)fetchAndCacheImageAtURL:(NSURL *)url
					forCallsign:(NSString *)callsign
				completionBlock:(ORSCallbookImageControllerCompletionBlock)block;

@end
