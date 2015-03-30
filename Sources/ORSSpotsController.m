//
//  ORSSpotsController.m
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ORSSpotsController.h"
#import <AetherCore/AetherCore.h>

@interface ORSSpotsController () <ORSDXClusterDelegate>

@property (nonatomic, strong) ORSDXClusterNode *clusterNode;

@property (nonatomic, strong) NSMutableArray *internalSpots;

@end

@implementation ORSSpotsController

- (instancetype)init
{
	self = [super init];
	if (self) {
		_internalSpots = [NSMutableArray array];
	}
	return self;
}

#pragma mark - ORSDXClusterDelegate

- (void)dxCluster:(ORSDXClusterNode *)cluster didReceiveSpots:(NSArray *)spots
{
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.internalSpots count], [spots count])];
	[self.internalSpots insertObjects:spots atIndexes:indexes];
}

- (void)dxCluster:(ORSDXClusterNode *)cluster didEncounterError:(NSError *)error
{
	NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

- (NSString *)loginStringForDXCluster:(ORSDXClusterNode *)cluster
{
	return @"AC7CF";
}

#pragma mark - Properties

+ (NSSet *)keyPathsForValuesAffectingDxClusterURL
{
	return [NSSet setWithObjects:@"clusterNode.url", nil];
}

- (NSURL *)dxClusterURL
{
	return self.clusterNode.url;
}

- (void)setDxClusterURL:(NSURL *)dxClusterURL
{
	self.clusterNode.url = dxClusterURL;
	[self.clusterNode connect];
}

+ (NSSet *)keyPathsForValuesAffectingSpots
{
	return [NSSet setWithObjects:@"internalSpots", nil];
}

- (NSArray *)spots { return [self.internalSpots copy]; }

- (void)insertObject:(ORSDXSpot *)spot inInternalSpotsAtIndex:(NSUInteger)index
{
	[self.internalSpots insertObject:spot atIndex:index];
}

- (void)insertInternalSpots:(NSArray *)array atIndexes:(NSIndexSet *)indexes
{
	[self.internalSpots insertObjects:array atIndexes:indexes];
}

- (void)addSpot:(ORSDXSpot *)spot
{
	[self insertObject:spot inInternalSpotsAtIndex:[self.internalSpots count]];
}

- (void)removeObjectFromInternalSpotsAtIndex:(NSUInteger)index
{
	[self.internalSpots removeObjectAtIndex:index];
}

- (void)removeInternalSpotsAtIndexes:(NSIndexSet *)indexes
{
	[self.internalSpots removeObjectsAtIndexes:indexes];
}

- (void)removeSpot:(ORSDXSpot *)spot
{
	NSUInteger index = [self.internalSpots indexOfObject:spot];
	if (index == NSNotFound) return;
	[self removeObjectFromInternalSpotsAtIndex:index];
}

@end
