//
//  ORSSpotsTableViewController.m
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ORSSpotsTableViewController.h"
@import AetherCore;
#import "ORSCallbookImageController.h"
#import "ORSSpotDetailViewController.h"

@interface ORSSpotsTableViewController () <ORSDXClusterDelegate>

@end

@implementation ORSSpotsTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.clusterNode = [ORSDXClusterNode dxClusterWithURL:[NSURL URLWithString:@"dxc.nc7j.com"]];
	self.clusterNode.delegate = self;
	[self.clusterNode connect];
}

#pragma mark - ORSDXClusterDelegate

- (void)dxCluster:(ORSDXClusterNode *)cluster didReceiveSpots:(NSArray *)spots
{
	[self.tableView reloadData];
}

- (void)dxCluster:(ORSDXClusterNode *)cluster didEncounterError:(NSError *)error
{
	NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

- (NSString *)loginStringForDXCluster:(ORSDXClusterNode *)cluster
{
	return @"AC7CF";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.clusterNode.spots count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotTableCell" forIndexPath:indexPath];
	
	ORSDXSpot *spot = self.clusterNode.spots[indexPath.row];
	cell.textLabel.text = spot.callsign;
	
	ORSCallbookImageController *imageController = [ORSCallbookImageController sharedCache];
	UIImage *image = [imageController imageForCallsign:spot.callsign];
	cell.imageView.image = image;
	
	if (!image) {
		// Try to fetch image
		NSString *imageURLString = spot.callbookInfo.imageURL;
		if ([imageURLString length]) {
			NSURL *url = [NSURL URLWithString:imageURLString];
			
			[imageController fetchAndCacheImageAtURL:url forCallsign:spot.callsign completionBlock:^(UIImage *image) {
					NSUInteger index = [self.clusterNode.spots indexOfObject:spot];
					if (index != NSNotFound) {
						NSIndexPath *spotPath = [NSIndexPath indexPathForRow:index inSection:0];
						[tableView reloadRowsAtIndexPaths:@[spotPath] withRowAnimation:UITableViewRowAnimationNone];
					}
			}];
		}
	}
	
	return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"SpotDetailSegue"]) {
		UITableViewCell *cell = (UITableViewCell *)sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		ORSDXSpot *spot = self.clusterNode.spots[indexPath.row];
		[(ORSSpotDetailViewController *)segue.destinationViewController setSpot:spot];
	}
}

@end
