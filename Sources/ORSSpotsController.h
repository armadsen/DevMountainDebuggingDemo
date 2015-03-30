//
//  ORSSpotsController.h
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORSSpotsController : NSObject

@property (nonatomic, strong) NSURL *dxClusterURL;

@property (nonatomic, readonly) NSArray *spots;

@end
